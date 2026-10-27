# DSD-8 Processor Project

This repository is a Digital System Design (DSD) project for a small 8-bit microprocessor. It provides the processor skeleton, verification infrastructure, assembler, golden simulator, testbench harness, and project automation used to validate the design.

The repository is intentionally structured as a starter project: core RTL files under `rtl/` are placeholders, and the goal is to implement the actual CPU behavior, validate it, and certify it against the reference model.

## Project goal

The goal of this project is to design and verify a working DSD-8 CPU in Verilog.

The processor includes:
- register file
- arithmetic/logic unit (ALU)
- flags register
- control unit
- instruction memory
- data memory
- program counter
- I/O bus
- top-level integration module

The final result is checked using simulation and conformance tests, comparing the design against a golden reference implementation.

## Repository structure

```text
.
├── README.md                 # project overview and usage guide
├── Makefile                  # main certification commands
├── CONTRIBUTING.md           # contribution and workflow guidance
├── rtl/                      # processor RTL module skeletons
│   ├── alu.v
│   ├── control_unit.v
│   ├── data_memory.v
│   ├── dsd8_cpu.v
│   ├── dsd8_top.v
│   ├── flags_reg.v
│   ├── instr_decoder.v
│   ├── instr_memory.v
│   ├── io_bus.v
│   ├── prog_counter.v
│   └── register_file.v
├── tb/                       # testbench files
│   ├── README.md
│   ├── tb_dsd8.v
│   └── tb_alu_example.v
├── sim/                      # peripheral models for simulation
│   └── peripherals.v
├── tools/                    # assembler and reference simulator
│   ├── dsd8asm.py
│   └── dsd8sim.py
├── tests/
│   ├── conformance/
│   └── README.md
├── scripts/
│   ├── install_hooks.sh
│   ├── lint.sh
│   ├── run_conformance.py
│   └── run_unit_tests.py
├── doc/                      # design and verification templates
├── .github/                  # CI workflows and project automation
├── githooks/                 # repo hooks
└── .gitignore
```

## Main files to work with

### RTL design files
The most important files are inside `rtl/`:

- `rtl/dsd8_cpu.v`
  - Main processor core
  - Connects the fetch, decode, execute, and writeback stages

- `rtl/prog_counter.v`
  - Tracks the current instruction address

- `rtl/instr_memory.v`
  - Stores machine code instructions

- `rtl/instr_decoder.v`
  - Decodes the instruction word and generates control signals

- `rtl/register_file.v`
  - Stores general-purpose CPU registers

- `rtl/alu.v`
  - Performs arithmetic and logic operations

- `rtl/flags_reg.v`
  - Tracks condition flags such as zero, carry, negative, and overflow

- `rtl/data_memory.v`
  - Implements memory storage for data instructions

- `rtl/control_unit.v`
  - Coordinates the CPU state machine and control signals

- `rtl/io_bus.v`
  - Handles I/O accesses for ports and peripherals

- `rtl/dsd8_top.v`
  - Top-level system integration

### Verification and reference files
- `tools/dsd8asm.py`
  - Assembles `.asm` programs into machine code

- `tools/dsd8sim.py`
  - Golden simulator used as the reference model

- `tb/tb_dsd8.v`
  - Official conformance harness used by the grading flow

- `scripts/run_conformance.py`
  - Runs the conformance pipeline

- `scripts/run_unit_tests.py`
  - Runs the unit tests for each module

- `Makefile`
  - Central entry point for lint, test, and conformance

## How the project works

The repository uses a standard digital-design validation flow:

1. Write assembly code in `tests/conformance/`
2. Assemble it using `tools/dsd8asm.py`
3. Simulate the correct program behavior with `tools/dsd8sim.py`
4. Compile your hardware design with Icarus Verilog
5. Run the simulation of the RTL design
6. Compare the generated execution trace with the golden trace
7. Fix mismatches until the design is correct

This is the core certification logic of the project.

## Typical workflow

### 1. Start with the specification and files
Read:
- `README.md`
- `tools/dsd8asm.py`
- `rtl/dsd8_cpu.v`
- `tb/README.md`

### 2. Understand the instruction set
The assembler defines how instructions are encoded. This is essential because the CPU must match the ISA exactly.

### 3. Implement the RTL modules
The order is usually:
- program counter
- instruction memory
- decoder
- register file
- ALU
- flags
- memory
- control unit
- I/O bus
- top-level CPU integration

### 4. Write unit tests
Each module should be tested separately using a self-checking testbench.

### 5. Run lint
```bash
make lint
```

### 6. Run unit tests
```bash
make test
```

### 7. Run conformance tests
```bash
make conformance
```

## Design concept

This project is a small CPU architecture with:
- 8-bit register operations
- instruction memory fetch
- decoder-driven control
- ALU-based calculation
- branch and comparison support
- memory accesses
- I/O communication through ports

The processor behaves like a simple educational microcontroller-like CPU, and the project is intended to teach both hardware design and verification discipline.

## Why this repository matters

This project is not just about writing Verilog. It teaches a full engineering workflow:
- design the hardware
- define the ISA and its encoding
- implement the modules
- validate behavior with tests
- compare to a golden model
- pass CI and conformance checks

This is the same mindset used in real digital hardware development: specification, implementation, verification, and certification.

## Built-in debug feature idea

This project is a good foundation for further novelty work. One strong extension would be a built-in debug mode inside the CPU, including:
- single-step execution
- breakpoint support
- trace buffer of recent instructions
- register dump
- flag and PC display

This makes the processor more practical for debugging and demonstration while still keeping the main architecture intact.

## Quick start

```bash
git clone <repo-url>
cd dsd8-SSJ
make lint
make test
make conformance
```

## Notes

The README in the original project states that the RTL modules are placeholders with frozen port lists and TODO comments. The real project assignment is to complete the design and certify it against the golden simulator and conformance tests.

This repository is a teaching and certification framework as much as it is a hardware design project.

## Summary

This project is a small microprocessor design challenge built around:
- Verilog implementation
- assembler and simulator tools
- unit tests and conformance verification
- CI-style validation workflow
- CPU design and debugging practice

The main focus is not only writing HDL, but proving it works under a strict comparison-based verification process.

---

This repository is intended for learning, experimentation, and project-based digital system design work.
