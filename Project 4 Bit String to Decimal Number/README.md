# Project 4: Bit String to Decimal Number

This project is a RISC-V assembly program that reads a file containing 32-bit binary strings (bit strings), converts each into a signed decimal integer using 2's complement representation, and displays the result along with the number of processed strings. The program also shows useful metadata such as the file descriptor and number of bytes read.

---

## Problem Description

Given an ASCII file smaller than 1024 bytes containing multiple 32-bit binary strings separated by spaces, the program must:

1. Open and read the file.
2. Detect and extract each 32-character binary string.
3. Convert each string to a signed 32-bit integer.
4. Display:
   - The file descriptor number
   - The number of bytes read
   - Each bit string with its decimal equivalent
   - The total number of bit strings found
   - A final termination message

This assignment is developed using the **Jupiter RISC-V Simulator**.

---

## File Structure

```
Project 4 Bit String to Decimal Number/
├── s1103558.s                                    # Assembly code
├── example2.txt                                  # Input file with 32-bit binary strings
├── Screenshot 2025-05-18 172711.pdf              # Output screenshot
├── Project 4 Bit String to Decimal Number.pdf    # Problem description
```

---

## How to Run

### Requirements

- **[Jupiter Assembler](https://github.com/andrescv/Jupiter)** (RISC-V ISA simulator)

### Steps

1. Open **Jupiter**.
2. Load the file: `s1103558.s`
3. Edit the following line inside the `.s` file to point to the correct full path of `example2.txt`:
   ```asm
   filename: .string "C:\\full\\path\\to\\example2.txt"
   ```
4. Click **Assemble** and then **Run** the program.

### Expected Output

- File descriptor number
- Number of bytes read from the file
- Each 32-bit binary string followed by its decimal representation
- Count of total bit strings found
- Final program termination message

Example (output shown in `s1103558.png`):

```
** The file descriptor number: 3
The number of bytes read: 218
00000000000000000000000000000000 0
11111111111111111111111111111111 -1
10101010101010101010101010101010 -1431655766
...
The number of bit strings is: 10
** Program terminated normally.
```

---

## References

- [Jupiter RISC-V Assembler](https://github.com/andrescv/Jupiter)
- Jupiter Documentation: https://jupitersim.gitbook.io/jupiter
