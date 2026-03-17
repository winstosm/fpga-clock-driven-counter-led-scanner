# fpga-clock-driven-counter-led-scanner
Clock-synchronous FPGA system deriving 1 Hz and 10 Hz signals from a 50 MHz clock to drive a three-digit decimal counter and one-hot LED scanning controller with verified multi-second timing behavior.
# FPGA Clock-Driven Counter and LED Scanning Controller  
Synchronous Timing, Clock Division, and Display Control in VHDL  

## Overview  
This project implements a clock-synchronous FPGA system that derives lower-frequency timing signals from a 50 MHz input clock to drive a three-digit decimal counter and LED scanning controller. The design demonstrates precise timing control, modular digital design, and real-time display operation.  

The system converts a high-frequency clock into 1 Hz and 10 Hz signals, enabling human-readable counting and controlled LED multiplexing.

---

## Key Features  
- Clock division from 50 MHz to 1 Hz and 10 Hz  
- Three-digit decimal counter (multi-stage counting logic)  
- One-hot LED scanning controller for display multiplexing  
- Fully synchronous design ensuring timing reliability  
- Verified multi-second timing behavior through simulation  

---

## System Architecture  

1. **Clock Divider**  
   Reduces the 50 MHz system clock into lower-frequency signals for timing control  

2. **Decimal Counter**  
   Implements multi-digit counting using cascaded logic for ones, tens, and hundreds  

3. **LED Scanning Controller**  
   Uses one-hot encoding to cycle through display outputs for efficient multiplexing  

---

## Technologies Used  
- VHDL  
- Quartus Prime  
- ModelSim  
- FPGA development board (DE2-115 / DE10-Lite)  

---

## File Structure  
- **src/** – VHDL source files  
- **testbench/** – Simulation and verification files  
- **simulations/** – Waveforms or output results (optional)  
- **docs/** – Diagrams, notes, or reports  

---

## Results & Validation  
- Accurate 1 Hz and 10 Hz timing derived from 50 MHz clock  
- Stable multi-digit counting behavior  
- Verified LED scanning and display refresh operation  
- Simulation confirms timing correctness over extended intervals  

---

## Engineering Significance  
This project demonstrates key digital system concepts including:
- Clock domain management and frequency division  
- Modular hardware design for scalability  
- Real-time display control using multiplexing  
- Timing verification in synchronous FPGA systems  

---

## Intellectual Property & Technical Perspective  
The structured design and modular architecture reflect principles relevant to:
- Hardware system documentation and technical disclosure  
- Patent analysis of digital timing and control systems  
- Evaluation of system-level innovation and implementation  

---

## Future Improvements  
- Expand to larger digit displays or dynamic input control  
- Integrate external inputs for configurable counting behavior  
- Optimize resource utilization and timing performance  

---

## Author  
Sabra Winston  
Electrical & Computer Engineering, Vanderbilt University  
Focus: FPGA Systems, Embedded Computing, and Technology & IP  
