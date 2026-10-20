# CALCULATOR: 4-Digit Decimal Calculator on FPGA

A hardware calculator written in VHDL for the EE 214 Digital Circuits Laboratory at IIT Bombay (Autumn 2026-27). A 4x4 keypad feeds a central control FSM, which performs signed arithmetic and shows the result on a multiplexed 4-digit 7-segment display. Results longer than four digits scroll across the display.

**Team:** Pranav Pavan Jaju (25B3961) and Pranshu Das (25B3962)

## Features

- Entry of two operands of up to 4 digits each
- Addition, subtraction and multiplication
- Erase digit and clear all
- Signed results with leading-zero suppression
- Scrolling display for results above 9999
- Keypad scanner with debouncing, built as a dedicated FSM
- Custom 7-segment decoder, with no decoder IC

## System overview

| Block | Role |
|---|---|
| Keypad interface | Scans the 4x4 matrix, synchronises and debounces inputs, and reports one key code per press |
| Calculator FSM | Routes key codes, holds operands, triggers the ALU and formats the result |
| Display controller | Multiplexes the four digits and scrolls long results |
| Decoder | Converts 4-bit codes to 7-segment patterns |

## Hardware and tools

- **FPGA:** Intel MAX 10, `10M25SAE144C8G` (Xen-10 board), 50 MHz clock
- **Peripherals:** WEL 4-digit 7-segment display board (common anode) and a 4x4 matrix keypad
- **Tools:** Quartus Prime Lite and ModelSim

## Repository structure

Each task is a separate Quartus project in its own folder, and `CALCULATOR` is the final integrated design.

```
LAB Project/
├── Task_1_A/    Display controller (BCD output)
├── Task_1_B/    Display controller with custom decoder
├── Task_2/      Keypad interface
├── Task_3/      Final integration (CALCULATOR)
└── README.md
```

## Build and simulate

1. Open the task's Quartus project and check the top-level entity and device.
2. Simulate the testbench in ModelSim with the shortened timing constants.
3. Switch the timing constants back to their board values (50 MHz clock) before compiling.
4. Assign pins, compile and program the board.

## Design conventions

- Port names in the provided entities are never changed, so modules can be integrated by name.
- Every control subsystem is implemented as an FSM.
- Plain course-level VHDL: `std_logic` types, `case` statements and one clocked process per job.

## Status

- [ ] Task 1: Display controller and decoder
- [ ] Task 2: Keypad interface
- [ ] Task 3: Integration and calculator FSM

## Course

EE 214 Digital Circuits Laboratory, Wadhwani Electronics Laboratory, Department of Electrical Engineering, IIT Bombay.
