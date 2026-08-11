# Integrated SPI Slave with Single-Port RAM — Design & UVM Verification Architecture

An end-to-end SystemVerilog implementation and Universal Verification Methodology (UVM) verification environment for a synchronized **SPI Slave with Single-Port Memory (RAM)** core. This repository documents the hardware design architecture, finite state machine (FSM) mechanics, and the UVM verification suite used to achieve full functional and assertion coverage.

---

## 🏗️ 1. Hardware Design Phase

The Design Under Test (DUT) consists of a 10-bit serial-to-parallel SPI Slave interface closely coupled with a 256x8-bit Single-Port RAM. The system operates on a shared clock (`clk`) and active-low asynchronous reset (`rstn`).

### System Top Architecture (`SPI_wrapper`)

![SPI Slave with Single Port RAM Top Architecture](images/design_top.png)

---

### A. SPI Slave Module (`SPI_slave`)
The SPI Slave handles protocol frame synchronization, serial-to-parallel input conversion (`MOSI`), and parallel-to-serial output conversion (`MISO`).

* **State Machine Mechanics**: Driven by a 5-state FSM:
  * `IDLE`: Waits for active-low Chip Select (`SS_n = 0`).
  * `CHK_CMD`: Examines the incoming opcode bits `rx_data[9:8]` once a 10-bit frame is latched.
  * `WRITE`: Active during write address (`00`) or write data (`01`) operations.
  * `READ_ADD`: Active during read address (`10`) setup operations.
  * `READ_DATA`: Active during read data (`11`) retrieval operations, enabling serial output onto `MISO`.
* **Serial Receive Stream (`MOSI`)**: Shifts 10 bits serially into `rx_data[9:0]`. When 10 bits are fully ingested, `rx_valid` pulses high to notify the RAM.
* **Serial Transmit Stream (`MISO`)**: When the memory asserts `tx_valid`, the slave latches the 8-bit `tx_data[7:0]` (`dout`) and shifts it out bit-by-bit on the `MISO` line.
* **Frame Boundary Control (`SS_n`)**: Driving `SS_n` high immediately aborts any active transaction, forces internal shift counters to zero, and returns the FSM to `IDLE`.

---

### B. Single-Port RAM Module (`RAM`)
The RAM serves as an internal target storage block containing a 256-depth by 8-bit array (`mem [0:255]`).

* **10-Bit Protocol Decoding (`din[9:8]`)**:
  * `2'b00` (**WRITE Address**): Latches `din[7:0]` into an internal write address register. `tx_valid` remains `0`.
  * `2'b01` (**WRITE Data**): Writes payload `din[7:0]` into memory at the previously latched write address. `tx_valid` remains `0`.
  * `2'b10` (**READ Address**): Latches `din[7:0]` into an internal read address register. `tx_valid` remains `0`.
  * `2'b11` (**READ Data**): Retrieves memory content at the read address, assigns it to `dout[7:0]`, and asserts `tx_valid` for **exactly 1 clock cycle**.

---

## 🧪 2. UVM Verification Phase

The verification environment is built on UVM 1.2 to systematically validate the design using constrained-random generation, SystemVerilog Assertions (SVA), reference modeling, and functional cross-coverage.

### Verification Environment Hierarchy (`Wrapper_Top`)

![UVM Verification Environment Architecture](images/uvm_arch.png)

---

### A. Component Breakdown
1. **Sub-Environments**:
   * `RAM_env`: Isolated testing of memory boundary conditions and read/write handshaking.
   * `slave_env`: Protocol testing of FSM transitions and serial bit shifting.
   * `wrapper_env`: Top-level active environment driving multi-cycle end-to-end SPI transactions.
2. **Configuration Database (`uvm_config_db`)**:
   * Connects `Wrapper_Interface`, `slave_Interface`, and `RAM_Interface` across all agents and monitors using top-level `set` and component `get` operations.
3. **Golden Reference Models**:
   * `slave_ref_model` & `wrapper_ref_model`: Behavioral SystemVerilog models run parallel to the DUT. Predicts expected parallel data and serial `MISO` streams to enable real-time automated comparison inside UVM scoreboards.
4. **Constrained-Random Sequences**:
   * Generates dynamic `MOSI`, `SS_n`, and `rst_n` driving patterns.
   * Enforces sequence-level distribution constraints (e.g., 60/40 read vs. write opcodes) and precise frame-timing limits (13 cycles for writes, 23 cycles for reads).

---

### B. SystemVerilog Assertions (SVA) Coverage
SystemVerilog assertions monitor design execution and signal stability:

* **RAM Assertions (`RAM_SVA`)**:
  * `a_reset_dout` / `a_reset_tx_valid`: Ensures outputs immediately reset to `0` when `rst_n` is asserted.
  * `low_tx_valid`: Enforces that `tx_valid` remains `0` during write address, write data, and read address commands.
  * `high_tx_valid`: Verifies `tx_valid` asserts for **exactly 1 clock cycle** during read data commands.
* **Slave Assertions (`slave_SVA`)**:
  * State Machine assertions verify next-state logic across `IDLE`, `CHK_CMD`, `WRITE`, `READ_ADD`, and `READ_DATA`.
  * Frame protocol assertions check that 10-bit packages trigger `rx_valid` precisely after 10 clock cycles.
* **Wrapper Assertions (`wrapper_SVA`)**:
  * `p_miso_stable`: Enforces that `MISO` remains `$stable` when current operations are not read data.

---

### C. Coverage Metric Summary

The test environment was simulated in **QuestaSim**.

| Metric | Target | Result | Status |
| :--- | :---: | :---: | :---: |
| **Functional Coverage** | 100% | **100.0%** | PASS |
| **Assertion Coverage (SVA)** | 100% | **100.0%** | PASS |
| **Simulated Random Transactions** | -- | **7,019** | PASS |
| **UVM Errors / Fatals** | 0 | **0 Errors / 0 Fatals** | PASS |

---

## 📁 Repository Directory Structure

```text
.
├── rtl/                        # Design Phase Modules
│   ├── RAM.v                   # Single-Port RAM module
│   ├── SPI_slave.v             # SPI Slave protocol engine
│   └── SPI_wrapper.v           # Integrated Top Wrapper
│
├── verif/                      # Verification Phase Modules
│   ├── assertions/             # SVA Modules
│   │   ├── RAM_SVA.sv
│   │   ├── slave_SVA.sv
│   │   └── wrapper_SVA.sv
│   ├── env/                    # UVM Envs, Agents, Scoreboards
│   │   ├── RAM_env.sv
│   │   ├── slave_env.sv
│   │   └── wrapper_env.sv
│   ├── ref_models/             # Behavioral Reference Models
│   │   ├── slave_ref_model.sv
│   │   └── wrapper_ref_model.sv
│   ├── sequences/              # UVM Sequences & Items
│   └── tests/                  # UVM Tests
│
├── sim/                        # Run Scripts
│   └── run.do                  # QuestaSim execution script
└── README.md