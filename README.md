# SDRAM Controller + UVM Testbench

UVM Testbench environment developed for verifying write/read functionality of SDRAM controller and memory SDRAM model. SDRAM rtl taken from https://github.com/yigitbektasgursoy/SDRAM_Verilog/tree/main

This folder contains RTL, UVM agents, sequences, and simulation artifacts used to exercise the controller and verify correct read-back behavior via a scoreboard.

**Key Features**

- `sdram_controller.v` — A simple controller implementing ACT/CAS/RAS command sequences, bank/row/column decoding and basic HBus-style interface signals (`in_HCLK`, `in_HRESET`, `in_HWRITE`, `in_HSEL`, `in_HWDATA`, `in_HADDR`).
- `sdram_model.v` — Behavioral SDRAM model with 4 banks, parameterized sizes, and cycle-aware read/write handling (covers NOP/ACT/READ_CAS/WRITE_CAS behavior).
- `sdram_top.v` — Top-level wrapper instantiating the controller and the SDRAM model for simulation.
- UVM testbench (SystemVerilog):
  - `src_agent/` — Source agent with driver/monitor/sequencer and sequences (`write_only_seq`, `write_read_seq`) that generate write and read transactions.
  - `dst_agent/` — Destination agent and monitor that collect read responses.
  - `tb/` — Testbench harness including `top.sv`, `environment.sv`, `scoreboard.sv`, `transaction.sv`, and config objects for `uvm_config_db` binding.
  - `test/` — `sdram_pkg.sv` and `test.sv` provide packaged tests (`write_only_test`, `write_read_test`) that drive sequences and verify data integrity via a scoreboard.

**Repository layout **

- `rtl/` — `sdram_controller.v`, `sdram_model.v`, `sdram_top.v`, `sdram_if.sv`, plus helpers.
- `src_agent/` — source-side UVM agent (driver, monitor, sequencer, sequences).
- `dst_agent/` — destination-side agent/monitor used to capture responses.
- `tb/` — UVM environment and top-level testbench (`top.sv`).
- `test/` — UVM package and test definitions.
- `sim/` — Simulation scripts, Makefile, coverage DBs, waveform and simulator outputs.

**How to run (example)**

1. Open a terminal in this folder's `sim` directory:

```bash
cd SDRAM-Controller-UVM-Testbench-Verification/sim
```

2. Run the provided Makefile target (example observed in this workspace):

```bash
make run_test1
```

Notes: The project contains simulation outputs (waveforms, `simv`, coverage DBs). The testbench uses UVM; compatibility with simulators (VCS/Modelsim/etc.) depends on your environment and the simulator Makefile configuration in `sim/`.

**Tests & Verification**

- `write_only_test` — generates write-only sequences to populate SDRAM.
- `write_read_test` — writes data then reads it back; the `scoreboard.sv` compares written (`src_agent`) vs read (`dst_agent`) values and reports success/failure.

**Developer Notes**

- `sdram_if.sv` provides a lightweight virtual interface used by drivers/monitors. If you extend functionality, update the interface and any monitors/drivers accordingly.
- The controller and model are intentionally simple and educational; timing parameters are modeled with NOP/command cycles in the FSM rather than detailed SDRAM timing constraints.
- The repository includes simulation artifacts (waveforms, coverage) — remove or clean `sim/` before committing if you prefer a smaller repo.

**Attribution**

The `tb/top.sv` contains a reference to an example repository. Portions of this testbench appear inspired by that example; please review and relicense appropriately if you plan to publish this code.


