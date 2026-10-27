# Lightweight JTAG-Compatible Debug Port for DSD-8 CPU

## Idea

We are implementing a lightweight JTAG-compatible debug interface as our novelty feature.

This is not a full JTAG solution or a full industrial boundary-scan design. Instead, it is a small debug port built into the CPU using a TAP-style control interface with:

- TCK
- TMS
- TDI
- TDO
- optional TRST

The goal is to make the processor easier to debug, easier to validate, and more professional-looking without making the design too complex.

---

## Why this is a good novelty

This is a strong novelty because it makes the CPU look and behave like a real embedded processor with a hardware debug interface.

It gives us:
- easier debugging
- step-by-step execution control
- breakpoint support
- register and flag readout
- instruction trace access
- a professional hardware-level debug story

This is more valuable than a cosmetic feature because it directly improves observability and testing.

---

## What “lightweight JTAG-compatible” means

Instead of implementing a full JTAG system with all advanced scan features, we add a small debug TAP (Test Access Port) interface.

This interface is enough to:
- shift debug commands into the CPU
- shift debug data out of the CPU
- enable debug mode
- read internal state
- step the processor
- stop at a breakpoint

It is a lightweight version of JTAG at the port level, but not a full JTAG standard implementation.

---

## Main debug features

### 1. Single-step execution
The CPU executes one instruction and then stops.

This is very useful for checking:
- PC movement
- register changes
- flag updates
- branch behavior
- memory access patterns

### 2. Breakpoint support
The CPU can stop execution when the program counter reaches a selected address.

This is helpful for debugging loops, conditional branches, and incorrect jumps.

### 3. Trace buffer
The CPU stores a short history of recently executed instructions.

Each trace entry can include:
- PC
- IR
- opcode
- register being written
- flags after execution
- memory address if used

### 4. Register and flag readout
The outside debug controller can read:
- PC
- current instruction
- R0..R7
- Z, N, C, V flags
- debug status register

### 5. Debug status output
The debug system can output state using:
- LEDs
- UART
- internal debug registers
- external debug port readout

---

## TAP controller overview

The lightweight debug interface uses a small TAP controller state machine.

The core states are:
- Test-Logic-Reset
- Run-Test/Idle
- Shift-IR
- Shift-DR
- Capture-DR
- Update-DR

This is a small subset of real JTAG, but enough to support the debug functionality we need.

---

## Example debug instructions

We can define a small instruction set for the debug port.

Examples:

- IDCODE
  returns a debug ID value

- DEBUG_STEP
  executes one instruction and stops

- DEBUG_RUN
  leaves debug mode and resumes execution

- SET_BREAKPOINT
  writes the address at which execution should stop

- READ_PC
  reads the current PC

- READ_REG
  reads a selected register value

- READ_FLAGS
  reads flag bits

- READ_TRACE
  reads the recent instruction trace

- READ_STATUS
  reads the debug state of the CPU

These are enough for a realistic debugging workflow.

---

## How the debug flow works

### Normal mode
The CPU runs normally.

The TAP controller is idle and does not affect execution.

### Debug mode enabled
The external debug tool shifts a command into the TAP controller using TDI.

The CPU decodes the instruction and enters debug mode.

### Single-step execution
If the command is DEBUG_STEP:
1. CPU executes one instruction
2. it stops
3. it updates the trace buffer
4. it outputs state through TDO
5. it waits for the next debug command

### Breakpoint execution
If a breakpoint is set:
1. CPU runs normally
2. when PC reaches the target address
3. CPU halts automatically
4. debug data is shifted out through TDO

### Resume execution
The user sends DEBUG_RUN.

The CPU exits debug mode and continues execution normally.

---

## Example session

Suppose the program is:

```asm
LDI R1, 5
LDI R2, 7
ADD R3, R1, R2
HLT
```

Debug workflow:

1. Shift SET_BREAKPOINT with the address of the ADD instruction.
2. Shift DEBUG_RUN.
3. CPU executes until it reaches the breakpoint.
4. CPU stops automatically.
5. Shift READ_PC and READ_REG.
6. The debug port returns:
   - PC = address of ADD
   - R1 = 5
   - R2 = 7
   - flags = previous state
7. Shift DEBUG_STEP.
8. CPU executes the ADD instruction.
9. Shift READ_REG to see R3 updated.

This is a very realistic debug flow.

---

## Why this is better than raw GPIO debug control

Without a JTAG-style port:
- debug commands are just software instructions
- the CPU ISA must be modified for debugging
- it is less standard
- it looks less professional

With a lightweight JTAG-compatible debug interface:
- the debug interface is external and standardized
- it is easier to connect to a debugger tool later
- it looks like real hardware design
- it is a stronger technical story for class

---

## Why we should not do full JTAG

We should not build full JTAG because it is too heavy for this project.

Full JTAG usually includes:
- boundary-scan logic
- scan chains across many modules
- complex testing infrastructure
- a much bigger protocol and design effort

That would be unnecessary for a small 8-bit processor.

The right approach is a minimal tap-based debug port used only for internal debugging and observation.

---

## Minimal hardware design

The smallest practical design is:

- 4-pin interface: TCK, TMS, TDI, TDO
- 1 TAP controller
- 1 instruction register (IR)
- 1 or 2 data registers (DR)
- 1 breakpoint register
- 1 debug status register
- read access to PC, register file, and flags
- trace buffer readout

This is enough to debug the CPU without overcomplicating the design.

---

## Files likely to be modified

### RTL
- `rtl/dsd8_cpu.v`
- `rtl/control_unit.v`
- `rtl/instr_decoder.v`
- `rtl/register_file.v`
- `rtl/dsd8_top.v`
- optionally `rtl/io_bus.v`

### Tools
- `tools/dsd8asm.py`
- `tools/dsd8sim.py`

### Testbench
- add a new debug testbench file such as `tb_debug_port.v`

---

## Implementation timeline

### Day 1
- define debug commands
- define TAP states
- define debug pins
- define read/write data registers

### Day 2
- implement TAP state controller
- implement debug instruction decode
- add debug mode signal

### Day 3
- implement breakpoint logic
- add trace buffer
- add PC and register read access

### Day 4
- add debug status output
- connect to LEDs or UART
- test stepping and dumping

### Day 5
- finalize demo program
- validate with unit tests and simulation
- prepare class demonstration

This is realistic and achievable in a few days.

---

## Final summary

Our novelty is a lightweight JTAG-compatible debug port for the DSD-8 CPU.

It includes:
- single-step execution
- breakpoint support
- trace buffer
- register and flag readout
- debug status output
- TAP-style command control using TCK, TMS, TDI, and TDO

This makes the processor look more professional, easier to debug, and closer to real embedded design while remaining lightweight and feasible for this project.

---

## Short professor-facing description

We are implementing a lightweight JTAG-compatible debug interface for the DSD-8 microprocessor. The system will support single-step execution, breakpoint control, instruction trace recording, and register/flag readout through a small TAP-based debug port using TCK, TMS, TDI, and TDO. This adds a real hardware debugging capability to the CPU and makes the design more practical, observable, and closer to modern embedded processor development.
