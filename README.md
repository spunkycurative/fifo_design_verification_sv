# FIFO Design Verification using SystemVerilog

## Overview

This project implements and verifies a synchronous FIFO (First-In-First-Out) using Verilog/SystemVerilog. The FIFO supports write, read, simultaneous read/write, and proper handling of overflow and underflow conditions. A self-checking, class-based verification environment is developed using SystemVerilog with assertions to validate the design.

---

# Features

- Synchronous FIFO (Single Clock)
- FIFO Depth: 16
- Data Width: 8-bit
- Circular buffer implementation using read/write pointers
- Counter-based Full and Empty flag generation
- Simultaneous Read & Write support
- Registered output (1-cycle read latency)
- Class-based verification environment
- Mailbox-based communication
- Self-checking scoreboard
- SystemVerilog Assertions (SVA)
- Dedicated Overflow Test
- Easily extendable for Underflow, Random and Simultaneous Read/Write testing

---

# Design Details

The FIFO is implemented using:

- 16 × 8-bit memory array
- Write Pointer (`wptr`)
- Read Pointer (`rptr`)
- Counter (`cnt`)

Status flags are generated as:

```
empty = (cnt == 0)
full  = (cnt == 16)
```

---

# Supported Operations

| Operation | Condition | Description |
|----------|-----------|-------------|
| Write | wr=1, rd=0 | Stores data into FIFO |
| Read | wr=0, rd=1 | Reads oldest data from FIFO |
| Simultaneous Read/Write | wr=1, rd=1 | Performs read and write in same cycle |
| Overflow | wr=1 when FIFO is Full | Write is ignored |
| Underflow | rd=1 when FIFO is Empty | Read is ignored |

---

# Verification Environment

The verification environment follows a class-based architecture.

### Transaction
- Defines FIFO transaction fields
- Contains write, read, input data, output data and status flags

### Generator
- Generates FIFO transactions
- Implements dedicated Overflow test
- Can be extended for:
  - Random Test
  - Underflow Test
  - Simultaneous Read/Write Test

### Driver
- Receives transactions through mailbox
- Drives DUT using virtual interface
- Performs reset sequence
- Applies synchronized FIFO transactions

### Monitor
- Samples DUT signals
- Captures FIFO status and transactions
- Sends observed transactions to scoreboard

### Scoreboard
- Queue-based reference model
- Verifies expected vs actual output
- Reports mismatches automatically

### Environment
- Connects all verification components
- Configures mailboxes and virtual interface
- Controls simulation flow (Pre-Test, Test, Post-Test)

---

# SystemVerilog Assertions

The project includes assertions to verify FIFO functionality, including:

- Overflow count check
- Underflow count check
- Full and Empty flag validation
- Counter limit verification
- Reset behavior
- Counter increment/decrement checks
- Simultaneous Read/Write counter check
- Write pointer increment
- Read pointer increment

---

# Simulation Results

The verification environment successfully validates:

- FIFO reset functionality
- Sequential write operations
- FIFO Full condition
- Overflow handling
- Counter behavior
- Pointer updates
- Status flag generation
- Scoreboard comparison
- Assertion-based protocol checking

Simulation completes with:

```
Scoreboard Errors = 0
```

Overflow assertion is expected to trigger when an additional write is attempted after the FIFO becomes full, confirming correct protocol verification.

---

# Project Structure

```
fifo_design_verification_sv/
│
├── design/
│   └── fifo.sv
│
├── tb/
│   ├── transaction.sv
│   ├── generator.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── environment.sv
│   ├── fifo_assertions.sv
│   ├── interface.sv
│   └── testbench.sv
│
└── README.md
```

---

# Tools Used

- SystemVerilog
- Riviera-PRO EDU
- EDA Playground
- Git & GitHub

---

# Future Enhancements

- Add constrained-random test generation for wider functional coverage.
- Implement functional coverage to measure verification completeness.
- Extend the environment to a UVM-based verification framework.
- Verify asynchronous (dual-clock) FIFO implementation.

---

# Author

**Shreya Sharma**

B.Tech Electronics & Communication Engineering

Aspiring Design Verification Engineer
