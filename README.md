# Crypto16 Coprocessor

## Project Overview
Crypto16 Coprocessor is a 16-bit, register-based hardware datapath that combines three operation classes in one compact execution path:

- arithmetic and logic operations
- fixed-pattern shift and rotation operations
- nonlinear substitution through an 8-bit LUT

The project is implemented in VHDL with a clear modular split between storage (`register_file`), operation selection (`combinational` + `control_unit`), and operation engines (`ALU`, `Shifter`, `NonlinearLut`).

This codebase is suitable for educational CPU/datapath labs, crypto-primitive experiments, and as a base for extending toward an instruction-driven micro-architecture.

## Purpose and Design Intent
The design demonstrates how to build a small coprocessor-like execution unit that can perform:

- standard ALU computation
- data permutation/positioning through shifts/rotations
- substitution-style transformation (S-Box-like behavior)

The implementation favors clarity over aggressive optimization, so each function can be inspected and tested independently.


## Top-Level Interface and Datapath
Entity: `crypto16_coprocessor`

### Inputs
- `Ra(3:0)`: source register A index
- `Rb(3:0)`: source register B index
- `Rd(3:0)`: destination register index
- `ctrl(3:0)`: operation control code
- `clk`: clock
- `res`: active-high reset

### Internal datapath sequence
1. `register_file` reads `ABus <- registers[Ra]`, `BBus <- registers[Rb]` asynchronously.
2. `combinational` computes `Result` from `ABus`, `BBus`, and `ctrl`.
3. On rising edge, `register_file` writes `Result` into `registers[Rd]` when `wrt='1'`.

### Control bookkeeping in top-level process
- `ctrl_temp` and `Rd_temp` are registered each cycle.
- `wrt` is set based on `ctrl_temp`.
- when `ctrl_temp = "0111"`, `wrt <= '0'`, otherwise `wrt <= '1'`.

Because `ctrl_temp` is itself clocked, this creates a one-cycle delayed write-disable effect.

## 5. Timing Model and Pipeline Interpretation
This is not a deep, multi-stage pipeline, but it has a repeatable two-phase cycle behavior.

### Phase A: combinational evaluation (between clock edges)
- source values are visible immediately through asynchronous register reads
- selected execution block computes candidate `Result`

### Phase B: sequential commit (clock edge)
- if `wrt='1'`, the candidate `Result` is committed to `registers[Rd]`
- control state (`ctrl_temp`, `Rd_temp`) updates

### Practical implication
The operation result itself can be produced in the same cycle, but state update happens at the next rising edge. In addition, write-disable for control `0111` applies with one-cycle control latency due to `ctrl_temp` usage.

## Register File: Async Read and Sync Write
Entity: `register_file`

### Storage and reset
- 16 entries, each 16-bit (`reg_data array (0 to 15) of std_logic_vector(15 downto 0)`)
- initialized to all zeros at declaration
- asynchronous reset clears all registers immediately when `res='1'`

### Write path
- write occurs only at rising edge of `clk`
- gated by `wrt`
- destination index comes from `Rd`

### Read path
- continuously driven outputs:
  - `ABus <= registers[to_integer(unsigned(Ra))]`
  - `BBus <= registers[to_integer(unsigned(Rb))]`

### Why this split is common
- asynchronous read minimizes operand access latency and control overhead
- synchronous write keeps architectural state changes edge-aligned and deterministic
- this combination is standard for small register-file-centric datapaths

## Execution Block: ALU
Entity: `ALU`

### Implemented ALU functions
- ADD
- SUB
- AND
- OR
- XOR
- NOT
- MOVE

### Arithmetic implementation details
Both ADD and SUB reuse the same `Adder_16bit`:

- ADD: `A + B + 0`
- SUB: `A + not(B) + 1` (two's complement subtraction)

Signals used:
- `adder_b_in <= not BBus when Ctrl=ALU_SUB else BBus`
- `adder_cin  <= '1' when Ctrl=ALU_SUB else '0'`

### Fallback behavior
For unsupported ALU controls, output is zeroed (`Result <= (others => '0')`).

## Adder Structure
### `Full_Adder`
- `sum  <= a xor b xor cin`
- `cout <= (a and b) or (b and cin) or (cin and a)`

### `Adder_16bit`
- ripple-carry topology using 16 `Full_Adder` instances
- carry chain from `carry(0)=cin` to `carry(16)=cout`

This favors structural simplicity and transparent behavior in simulation.

## Nonlinear LUT Block
Entity: `NonlinearLut`

### What it does
- takes one byte (`LutIn(7:0)`)
- splits into two nibbles (`S_Box1 = upper`, `S_Box2 = lower`)
- applies independent nibble substitutions
- returns transformed byte (`LutOut`)

### System-level integration
Inside `combinational.vhd`:

- only lower byte of `ABUS` is substituted
- upper byte of `ABUS` passes through unchanged
- final value: `LUT_out <= ABUS(15 downto 8) & LUT_out_temp`

This means LUT operation acts as a byte-local nonlinear transform in the low 8 bits.

### Nibble substitution tables
| In | S_Box1 (Upper nibble) | | In | S_Box2 (Lower nibble) |
|----|-----------------------|----|----|-----------------------|
| 0  | 1  | | 0  | F  |
| 1  | B  | | 1  | 0  |
| 2  | 9  | | 2  | D  |
| 3  | C  | | 3  | 7  |
| 4  | D  | | 4  | B  |
| 5  | 6  | | 5  | E  |
| 6  | F  | | 6  | 5  |
| 7  | 3  | | 7  | A  |
| 8  | E  | | 8  | 9  |
| 9  | 8  | | 9  | 2  |
| A  | 7  | | A  | C  |
| B  | 4  | | B  | 1  |
| C  | A  | | C  | 3  |
| D  | 2  | | D  | 4  |
| E  | 5  | | E  | 8  |
| F  | 0  | | F  | 6  |

## Shifter Block
Entity: `Shifter`

Implemented operations:

- `1000`: rotate right by 8 bits (`ror 8`)
- `1001`: rotate right by 4 bits (`ror 4`)
- `1010`: logical shift left by 8 bits (`sll 8`)
- others: output all zeros

The shifter uses `unsigned` conversions to apply shift/rotate operators and casts back to `std_logic_vector`.

## Opcode Map and Result Selection
### ALU opcode constants (`OP_codes.vhd`)
- `0000` -> ALU_ADD
- `0001` -> ALU_SUB
- `0010` -> ALU_AND
- `0011` -> ALU_OR
- `0100` -> ALU_XOR
- `0101` -> ALU_NOT
- `0110` -> ALU_MOVE

### Global result source selection (`combinational.vhd`)

The decode and block-select logic is centralized in `control_unit.vhd` and instantiated inside `combinational.vhd`.

`control_unit` outputs:
- `sel_block(1:0)`: selected execution block
- `alu_en`: ALU class enable
- `shifter_en`: Shifter class enable
- `luu_en`: LUT class enable

Decode behavior:
- `0000` to `0111`: `sel_block="00"`, ALU enabled
- `1000` to `1010`: `sel_block="01"`, Shifter enabled
- `1011`: `sel_block="10"`, LUT enabled
- all other codes: invalid/default path (`sel_block="11"`, all enables low, `Result=x"0000"`)

### Special note on `0111`
- `0111` is routed to ALU selection range in `combinational`
- ALU itself does not define `0111`, so ALU fallback is zero
- top-level control uses delayed `ctrl_temp="0111"` to disable write in following cycle

This makes `0111` functionally a control-oriented code in the integrated system.

## Initial Values and Reset Behavior
Observed initial/reset behavior in implementation:

- register file array starts at zero (`(others => (others => '0'))`)
- async reset in `register_file` forces all zeros immediately
- top-level reset branch sets `ctrl_temp` and `Rd_temp` to zero
- most TB signals start from zero values before directed stimulus

In system terms, reset drives design to a deterministic all-zero state for stored register contents and top-level temporary control registers.

## Verification Assets and Coverage
Testbenches provided in `sim/` validate unit-level and integrated behavior.

### Unit-level benches
- `Adder_16bit_TB.vhd`: adder correctness, carry behavior, overflow-style scenarios
- `ALU_TB.vhd`: ADD/SUB/AND/OR/XOR/NOT/MOVE directed checks
- `shifter_TB.vhd`: all listed shift controls and out-of-range fallback
- `NonLinearLut_TB.vhd`: LUT nibble substitution sweep (directed loop values)
- `register_file_TB.vhd`: reset, write enable, readback path behavior
- `control_unit_TB.vhd`: control decode class sweep (ALU/Shifter/LUT/invalid)

### Integration benches
- `combinational_TB.vhd`: source multiplexing across ALU/Shifter/LUT regions
- `crypto16_coprocessor_TB.vhd`: full operation sequence through register file and top-level control

### Verification style
The benches are directed-stimulus simulations with expected outcomes documented in comments and report messages. They are practical for functional bring-up and waveform inspection.

## Design Characteristics and Practical Notes
- The design is modular and readable, with clear unit boundaries.
- Arithmetic is structurally explicit via ripple-carry adder composition.
- Global decode ownership is now in `control_unit.vhd`, instantiated by `combinational.vhd` for block selection.
- `Rd_temp` is written in top-level process but not used for destination selection in current implementation.
- Write-enable behavior tied to `ctrl_temp` introduces a delayed control effect by construction.