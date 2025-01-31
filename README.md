# 1965 Ford Thunderbird Taillights on FPGA

A **real-time taillight simulation** built for replicating the iconic 1965 Ford Thunderbird taillight behavior using an FPGA and ModelSim.

## Features
- **Turn Signal Patterns**: Simulates left and right turn signals with sequential lighting.
- **Hazard Lights**: Activates all taillights simultaneously when hazard lights are enabled.
- **Brake Lights**: Activates all taillights at full brightness when the brake is applied.
- **Running Lights**: Implements a **dimming effect** for running lights using a toggle mechanism.
- **Reset Functionality**: Resets the system to the default state when the reset signal is active.

## Technologies Used
- **Hardware Description Language**: SystemVerilog
- **Simulation Tool**: ModelSim
- **FPGA Synthesis**: Compatible with Xilinx Vivado, Intel Quartus, or other FPGA toolchains
- **State Machine Design**: Finite State Machine (FSM) for taillight pattern control

## How It Works
1. **Finite State Machine (FSM)**: Controls the taillight patterns based on inputs (turn signals, hazard lights, brake lights).
2. **Dimming Effect**: A separate clock (`clk_dimmer_i`) toggles the running lights for a dimming effect.
3. **Output Logic**: Combines FSM patterns with dimming and brake logic to produce the final taillight output.
4. **Simulation**: Test the design in ModelSim to verify taillight behavior under different input conditions.

John Hagedorn - Computer Engineering @ UCSB
