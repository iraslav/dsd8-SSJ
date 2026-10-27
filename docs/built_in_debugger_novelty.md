# Built-in Debugger Novelty for DSD-8 CPU

## Idea

Add a lightweight built-in debugger to the DSD-8 processor so the CPU can debug itself while running. This is not a full external debugger or a JTAG-like system. It is a small internal debug mode built directly into the processor core.

The goal is to make the CPU behave like a real embedded device that can:
- run normally
- stop on command
- execute one instruction at a time
- halt at a breakpoint
- dump internal CPU state
- show the last executed instructions

This makes the project feel more advanced and practical than a plain CPU implementation.

---

## Why this is a strong novelty

This idea is useful, visible, and easy to explain in a class demo.

It is better than just adding more instructions because it adds real engineering value:
- easier debugging
- easier testing
- better observability
- stronger hardware validation story
- stronger demo for evaluation

A normal processor executes code. A debug-enabled processor can also inspect itself.

That turns the project from a simple CPU implementation into a more professional embedded-system design.

---

## Main debugger features

### 1. Single-step mode
The processor can execute one instruction and then stop automatically.

This lets the user observe:
- program counter
- memory address
- instruction word
- register file content
- flags
- memory write operations

This is the most basic and most valuable debugging tool.

### 2. Breakpoint support
A breakpoint stops execution when the program counter reaches a chosen address.

Example:
- stop at instruction 0x0010
- inspect CPU state
- continue execution manually

This helps debug loops, branch logic, and incorrect jumps.

### 3. Trace buffer
The CPU stores a short log of recent instructions.

Each trace entry can include:
- PC value
- instruction register (IR)
- opcode
- source/destination registers
- flags
- memory address if used

This gives a quick history of what happened just before the CPU stopped.

### 4. Register dump
The debugger can output:
- all general-purpose registers R0..R7
- current PC
- current flags
- status mode

This is very helpful for checking whether the processor is behaving correctly.

### 5. Status output
The debug module can expose current state using:
- LEDs
- UART output
- internal register values
- debug bus / port output

This makes the feature visible during a demo.

---

## Debugger workflow

### Normal operation mode
The CPU runs normally without interruption.

The debug logic stays in the background but does not block operation.

### Debug mode activation
The CPU can enter debug mode by:
- a special debug instruction
- a reset or control signal
- a debug bit set by software or hardware

### Single-step execution
Once debug mode is active:
1. CPU executes one instruction
2. it stops
3. it updates the trace log
4. it exposes the CPU state to the user
5. it waits for the next debug command

### Breakpoint execution
If a breakpoint is enabled:
1. CPU executes normally
2. when PC reaches the breakpoint address
3. CPU halts automatically
4. debugger outputs current CPU state

### Resume execution
The user can continue execution by sending a debug command such as:
- RUN
- STEP
- CONTINUE
- EXIT_DEBUG

---

## Example debug commands

The debug feature can be controlled by a small set of custom instructions.

Suggested commands:

- `DBG_STEP`
  - execute one instruction and stop

- `DBG_RUN`
  - leave debug mode and continue normal execution

- `DBG_BREAK addr`
  - set a breakpoint at a target address

- `DBG_DUMP`
  - dump registers, PC, and flags

- `DBG_TRACE`
  - output the trace buffer

- `GET_PC`
  - return current PC value

- `GET_REG Rd`
  - return register value for a certain register

These commands are simple, human-readable, and easy to add into the ISA and assembler.

---

## Internal structure

The debugger can be added as a small internal controller next to the main CPU control logic.

### Proposed internal signals

- `debug_enable`
- `debug_mode`
- `single_step`
- `breakpoint_enable`
- `breakpoint_pc`
- `trace_valid`
- `trace_index`
- `trace_buffer[0..N-1]`
- `status_reg`

### Debugger states
A simple debug state machine could be:

- `NORMAL`
- `DEBUG_WAIT`
- `STEP_ONE`
- `BREAKPOINT_HIT`
- `DUMP_STATE`
- `TRACE_STATE`
- `RESUME`

This is small and manageable for a university project.

---

## CPU interaction with debug logic

The main CPU still performs normal fetch/decode/execute/writeback.

The debug block watches the core and does the following:

- on every retired instruction, update the trace buffer
- check whether debug mode is active
- if single-step is active, stop after one instruction
- if PC matches breakpoint, stop execution
- if dump command is active, expose register values

This means the debug module is a lightweight observer and controller, not a completely separate CPU.

---

## Why this is practical for this repo

This repository already has the necessary structure:
- `rtl/dsd8_cpu.v` for the main CPU core
- `rtl/control_unit.v` for control decisions
- `rtl/instr_decoder.v` for decode logic
- `rtl/register_file.v` for register access
- `rtl/dsd8_top.v` for output integration

The debugger can be added cleanly without rewriting the processor architecture.

---

## Files likely to be modified

### RTL files
- `rtl/dsd8_cpu.v`
- `rtl/control_unit.v`
- `rtl/instr_decoder.v`
- `rtl/register_file.v`
- `rtl/dsd8_top.v`
- optionally `rtl/io_bus.v` if debug output is sent through ports

### Tools and assembler
- `tools/dsd8asm.py`
  - add debug instruction assembly support
- `tools/dsd8sim.py`
  - add golden behavior for debug operations

### Testbenches
- `tb/tb_alu_example.v` or new debug testbench
- new testbench file such as `tb_debugger.v`

### Conformance/demo programs
- add a small demo assembly program that uses:
  - breakpoint
  - single-step
  - trace dump

---

## Example demo program

```asm
; Example debug demonstration

LDI R1, 5
LDI R2, 7
ADD R3, R1, R2
CMP R3, R2
BNE end
LDI R4, 0
end:
HLT
```

Debug actions:
1. set breakpoint at `end`
2. run until breakpoint
3. dump registers
4. show trace buffer
5. continue execution with `DBG_RUN`

This makes the debugger visible and understandable for the audience.

---

## Implementation timeline (2 to 5 days)

### Day 1
- choose debug command set
- define debug state machine
- decide output method (LED/UART/register dump)
- define trace format

### Day 2
- add debug instruction decoding
- add debug mode control signals
- create status register and debug mode flag

### Day 3
- implement trace buffer logic
- implement single-step control
- add PC and IR tracking

### Day 4
- implement breakpoint support
- implement register dump
- connect debug output to ports or UART

### Day 5
- create testbench
- run unit tests
- run conformance tests
- prepare demo presentation

This is realistic and safe for a team project.

---

## How it feels in class

This feature makes the CPU feel like a real system instead of just a toy design.

The audience can see:
- the CPU is not just calculating values
- the CPU can pause and inspect its own state
- the CPU can show recent execution history
- the CPU can stop at key points in the program

This makes the project look professional and polished.

---

## Final summary

The built-in debugger is a strong novelty for this repository because it is:
- practical
- demonstrable
- useful for debugging
- easy to explain
- realistic for a 2–5 day extension

It is much closer to real embedded-system design than a purely cosmetic feature.

This gives the project a better story:

“We did not only build a processor. We built a processor with a built-in debug mode that can single-step, trace execution, and pause at breakpoints.”

---

## Recommendation

If you want one novelty that is very likely to impress the class and still remain feasible, choose the built-in debugger feature.

It is a good balance of:
- novelty
- practicality
- technical depth
- ease of implementation
- strong demo value

This is a safer and stronger choice than trying to redesign the whole CPU architecture.

