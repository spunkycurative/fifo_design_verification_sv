# fifo_design_verification_sv

# Overview

This project implements and verifies a synchronous FIFO (First-In-First-Out) memory using Verilog/SystemVerilog. The design supports write, read, and simultaneous operations with proper handling of full and empty conditions. A self-checking testbench is developed using class-based verification concepts.

# Key Features
1. Synchronous FIFO design (single clock)
2. Depth: 16, Width: 8-bit
3. Circular buffer implementation using pointers
4. Full & Empty flag generation using counter
5. Simultaneous read/write support
6. Registered output (1-cycle read latency)
7. Self-checking testbench with scoreboard
8. Random stimulus generation
9. Assertions for overflow and underflow detection
    
# Design Details
The FIFO is implemented using:

Memory Array: mem[15:0]
1. Pointers:
    wptr → Write pointer
    rptr → Read pointer
2. Counter (cnt):
    Tracks number of elements in FIFO
    Used to generate:
     empty = (cnt == 0)
     full = (cnt == 16)

###  Operations Supported

| Operation      | Condition        | Behavior                                  |
|---------------|------------------|-------------------------------------------|
| Write Only    | `wr=1, rd=0`     | Data written, `wptr++`, `cnt++`           |
| Read Only     | `wr=0, rd=1`     | Data read, `rptr++`, `cnt--`              |
| Simultaneous  | `wr=1, rd=1`     | Read & write together, `cnt` unchanged    |
| Full Case     | `wr=1, full=1`   | Write blocked                            |
| Empty Case    | `rd=1, empty=1`  | Read blocked                             |


Important Design Behavior:
-> Read Latency: 1 Clock Cycle

Data appears on dout one cycle after rd=1
Due to registered output design
Ensures stable and synthesizable hardware behavior


# Verification Environment:
A class-based testbench is used with the following components:
1. Transaction
Contains wr, rd, din, dout, full, empty
2. Generator
Generates random read/write transactions
Uses constraints for balanced stimulus
3. Driver
Drives DUT signals via virtual interface
Handles valid read/write conditions
4. Monitor
Samples DUT outputs
Includes assertions:
Prevent write when full
Prevent read when empty
5. Scoreboard
Uses queue model for reference
Compares expected vs actual output
Reports mismatches
6. Environment
Connects all components
Controls simulation flow

# Waveform Explanation
din shows input data being written
dout updates only after read operations
empty deasserts after first write
full remains low (FIFO never filled completely)
wptr, rptr, and cnt track internal FIFO state

*dout remains constant during write-only operations since data is only output during reads.

# Assertions Used
assert(!(wr && full && !rd)) else $error("FIFO Overflow")

assert(!(rd && empty)) else $error("FIFO Underflow")

# Project Structure
```
fifo-project/
│
├── design/
│   └── fifo.sv
│
├── tb/
|   ├── interface.sv
│   ├── transaction.sv
│   ├── generator.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── environment.sv
│   └── top.sv
│
└── README.md

```













   
