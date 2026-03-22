
# Configurable Hierarchical Decoder (Verilog)

## Overview
This project implements a configurable hierarchical decoder using Verilog HDL. The design dynamically operates as a 2-to-4, 3-to-8, or 4-to-16 decoder based on a mode selection input.

## Features
- Supports multiple decoder configurations:
  - 2→4 decoder
  - 3→8 decoder
  - 4→16 decoder
- Mode-based selection using `mode_sel`
- Enable signal to control output activation
- Modular and hierarchical design
- Includes self-checking testbench with automated PASS/FAIL validation


## Design Description
The decoder is built using smaller decoder modules:
- `decoder_2to4`
- `decoder_3to8`
- `decoder_4to16`

These modules are instantiated in a top-level module:
- `configurable_decoder`

The output is selected based on the `mode_sel` input:
- `00` → 2-to-4 decoder
- `01` → 3-to-8 decoder
- `10` → 4-to-16 decoder
- `11` → Invalid mode (output = 0)

## Inputs and Outputs
- Inputs:
  - `data_in` (4-bit)
  - `mode_sel` (2-bit)
  - `enable` (1-bit)

- Output:
  - `decode_out` (16-bit)

## Working
- When `enable = 0`, all outputs are forced to 0
- When enabled, the decoder corresponding to `mode_sel` is activated
- Output is selected using conditional logic

## Testbench
- Verifies all modes:
  - Disabled condition
  - 2→4 mode
  - 3→8 mode
  - 4→16 mode
  - Invalid mode handling
- Outputs validated using expected values

## Tools Used
- Verilog HDL
- Simulation tools (Vivado / ModelSim)

## Results
- Correct decoding observed for all configurations
- Successful verification through testbench
  ## Simulation Results
-Waveform
- Schematic Design


## Conclusion
This project demonstrates hierarchical design and modular implementation in digital systems using Verilog.
