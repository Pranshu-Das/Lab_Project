# 4-Digit Decimal Calculator on FPGA (CALCULATOR)

EE 214 Digital Circuits Laboratory, Electrical Engineering, IIT Bombay (Autumn 2026-27)

A fully hardware 4-digit decimal calculator written in VHDL. A 4x4 matrix keypad feeds a central calculator FSM, which does signed arithmetic and shows the result on a multiplexed 4-digit 7-segment display. Results longer than four digits scroll across the display.

**Team**
- Pranav Pavan Jaju (25B3961)
- Pranshu Das (25B3962)

## Target hardware

| Item | Details |
|---|---|
| FPGA | Intel/Altera MAX 10, `10M25SAE144C8G` (Xen-10 board) |
| Clock | 50 MHz master clock (to be confirmed on the board) |
| Display | WEL 4-digit multiplexed 7-segment board, common anode (J1 BCD mode, J2 bypass mode) |
| Input | 4x4 matrix keypad |
| Tools | Quartus Prime Lite, ModelSim |

## Features

- **Display controller:** dual-clock design with a refresh tick of about 1 kHz for multiplexing and a scroll tick of about 2 Hz for shifting.
- **Custom 7-segment decoder:** purely combinational, with digits 0-9, a minus sign and blanking.
- **Keypad interface:** column scanner with a two-flop input synchroniser and a 17.5 ms debounce, one event per key press, built as a dedicated FSM.
- **Central calculator FSM:** operand entry (up to 4 digits each), `+`, `-`, `x`, `=`, erase (`*`) and clear all (`#`).
- **Signed output:** negative results show a minus token, with leading-zero suppression.
- **Scrolling results:** any result above 9999 scrolls right to left.

## Repository layout

Each task is a separate Quartus project in its own folder, as the course requires. File names match entity names.

```
LAB Project/
├── Task_1_A/    Display controller, BCD output via J1 (on-board 74LS47 decodes)
│   ├── seven_seg_scroll_bcd.vhd
│   └── tb_seven_seg_scroll_bcd.vhd
├── Task_1_B/    Display controller + own decoder via J2 (bypass mode)
│   ├── seven_seg_scroll.vhd
│   ├── seven_seg_decoder.vhd
│   ├── tb_seven_seg_decoder.vhd
│   └── tb_seven_seg_scroll.vhd
├── Task_2/      Keypad interface and debouncer
│   └── keypad_interface.vhd
├── Task_3/      Final integration (top-level calculator_top)
└── README.md
```

The integrated Quartus project is named `CALCULATOR`, with `calculator_top` as its top-level entity.

## Project tasks

| Task | Description | Due (Thu / Fri batch) |
|---|---|---|
| 1A | Scrolling `1 2 3 4 5 6 7 8 9 0` using BCD output through J1 | Oct 22 / Oct 23, 2026 |
| 1B | Same scroll engine with our own decoder through J2; stream `3 9 6 1 - 3 9 6 2` | Oct 22 / Oct 23, 2026 |
| 2 | 4x4 keypad scanner, debounce FSM, LED verification | Oct 29 / Oct 30, 2026 |
| 3 | Central calculator FSM, ALU, signed display and scrolling | Nov 5 / Nov 6, 2026 |

## Architecture (Task 1)

```
clk -> tick generators -> mux_tick, scroll_tick
                           |
        scroll engine -> current_digits (4 symbols)
        mux FSM (DIG1..DIG4) -> digit_idx, sel_raw
                           |
                  code_now = current_digits(digit_idx)
                    |                         |
          Part A: -> bcd_out        Part B: -> seven_seg_decoder -> seg_out
                           |
        output register (segments and selects on the same edge, no ghosting)
```

Both parts share the same engine and differ only in what happens to `code_now`.

### Symbol codes

| Symbol | Part A (to 74LS47) | Part B (to own decoder) |
|---|---|---|
| 0-9 | `0000`-`1001` | `0000`-`1001` |
| Minus | not used | `1010` |
| Blank | `1111` | `1110` |

### Polarity constants

The board is common anode, so the real polarity is confirmed on hardware.

| Constant | Default | Meaning |
|---|---|---|
| `SEL_ACTIVE_LOW` | `'0'` | `'1'` inverts `sel_out` |
| `SEG_ACTIVE_LOW` | `'1'` | `'1'` inverts `seg_out` and `dp_out` (Part B only) |

The decoder itself is always active-high. Inversion happens only at the output of `seven_seg_scroll`.

## Simulation vs board timing

| Constant | Simulation | Board (50 MHz) |
|---|---|---|
| `MUX_LIMIT` | 4 | 50000 |
| `SCROLL_LIMIT` | 40 | 25000000 |

Always simulate with the small values and switch back to the board values before compiling for the lab. Search for `-- SIM` to make sure nothing is left over.

## Building and running

1. Open the task folder's Quartus project (device `10M25SAE144C8G`).
2. Check the top-level entity and the pin assignments in Pin Planner.
3. Compile with the board timing constants.
4. Program the board, set `reset` high then low, then set `start` high.
5. For simulation, run the matching testbench in ModelSim with the simulation constants and check the waveform.

**Part B hardware:** bridge jumpers JP1 and JP2 for bypass mode and use the J2 header only.

## Status

- [ ] Task 1A: Part A scroll engine and testbench
- [x] Task 1B: decoder and testbench (simulated), Part B top with stub
- [ ] Task 1: merge, board constants, lab demo
- [ ] Task 2: keypad interface
- [ ] Task 3: integration and calculator FSM

## Rules we follow

- Port names in the given entities are never changed, because later tasks instantiate modules by name.
- Every control subsystem is a dedicated FSM, and the state diagrams go in the report.
- Coding style is course level only: `std_logic` types, `case` statements, and one clocked process per job.

## Course

EE 214 Digital Circuits Laboratory, Wadhwani Electronics Laboratory, Department of Electrical Engineering, IIT Bombay.
