# Simple CPU

## Overview

This project implements a basic, 5-stage CPU design in Verilog. It supports fundamental operations with a simple pipeline and modular components. The design is intended as an introduction to RTL design and CPU architecture.

## Features

* 5-stage CPU pipeline: Fetch, Decode, Execute, Memory, Writeback (controlled via a state machine)
* Instruction set includes:

  * Load Word (lw)
  * Store Word (sw)
  * Branch if Equal (beq)
  * Branch if Less Than (blt)
  * Arithmetic: Add, Subtract, AND, OR
* Modular components:

  * CPU top module
  * InstructionMemory with hardcoded instructions
  * Decoder for instruction parsing
  * RegisterFile (256 registers, 2 read ports, 1 write port)
  * ALU (arithmetic and comparison operations)
  * DataMemory for load/store
* Unit tested individual modules with testbenches

## Modules Description

**CPU**
Controls program counter and pipeline stages. Implements a simple 4-state cycle.

**InstructionMemory**
Preloaded with instructions for simulation.

**Decoder**
Decodes 32-bit instructions into opcode and register addresses.

**RegisterFile**
256 registers with two asynchronous read ports and one synchronous write port.

**ALU**
Performs add, subtract, AND, OR and branch condition evaluations.

**DataMemory**
Supports memory read and write operations.

## Usage

* Compile and simulate the CPU module.
* Use testbenches to verify modules.
* Observe execution stages and verify results using waveform tools.

## Limitations

* No hazard detection or forwarding.
* No pipeline stalls or flushes.
* Hardcoded instruction memory.
* Address width inconsistencies.
* Intended for educational use.

## Author

Jonathan Joslin\\
