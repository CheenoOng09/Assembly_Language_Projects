# Project 2: StringToNumber Instruction Count

This RISC-V assembly project reads numbers from a text file and counts how many instructions were executed during the process. It also converts the byte stream into decimal numbers and prints them along with the total instruction count.

## Files

- `s1103558.s` – Final implementation of the program that counts instructions.
- `stringToNumber.s` – The original version of the StringToNumber converter.
- `example1.txt` – Sample input file with integers.
- `example2.txt` – Sample input file with multiple lines of integers.
- `example3.txt` – Sample input with mixed formatting.
- `example4.txt` – Final input used in the instruction-count version of the code.
- `s1103558.png` – Screenshot showing correct output.

## Project Description

The goal of this project is to:

1. Load a text file containing a series of numbers (space- or newline-separated).
2. Parse and convert the strings to integers.
3. Store and print the integers to confirm correct parsing.
4. Count and display the total number of RISC-V instructions executed during parsing.

This project uses a combination of control structures, register manipulation, and memory addressing in Jupiter Assembler format (`.s` files).

## How to Run

### Requirements

- [Jupiter Assembler](https://github.com/andrescv/jupiter)

### Steps

1. Download and install **Jupiter Assembler** from the link above.

2. Open Jupiter and load `s1103558.s`.

3. Make sure the `pathR` string inside the assembly file points to the full path of one of the provided example files:
```
pathR: .string "D:\path\to\example4.txt"
```
> Modify this line to match your local file system.

4. Assemble and run the program.

5. Observe the printed integers and the final message:

```cpp
Total number of instructions executed: <number>
```

## Notes

- Each `.txt` file represents a different test case to check parsing robustness.
- This version of the program includes embedded counters to track instructions at key parts of the code.
- The instruction count is accumulated manually by adding counters after every instruction block.
