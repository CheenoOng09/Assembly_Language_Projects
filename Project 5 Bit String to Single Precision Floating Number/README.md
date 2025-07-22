# Project 5: Bit String to Single Precision Floating Number

## Description

This project implements a RISC-V assembly program that reads a text file containing 32-bit binary strings and converts each into its corresponding **IEEE 754 single-precision floating-point number**. The program prints:
- The **floating part** calculated from the mantissa and sign.
- The **exponent part**.
- The **final decimal value**.
- Special outputs for **NaN** and **Infinity** when applicable.

This project was developed using the **RARS** simulator.

---

## Files

| File Name         | Description                                  |
|------------------|----------------------------------------------|
| `s1103558.asm`    | RISC-V Assembly source code (RARS compatible) |
| `input.txt`       | Input text file containing 32-bit binary strings |
| `Project 5 Bit String to Single Precision Floating Number.pdf` | Problem statement and requirements |
| `s1103558.png`    | Screenshot of successful execution output (not included here) |

---

## How to Run

### Step 1: Download and Run RARS

1. Download RARS from the official GitHub repository:  
   [https://github.com/TheThirdOne/rars/releases/tag/v1.6](https://github.com/TheThirdOne/rars/releases/tag/v1.6)

2. Launch RARS with the command:
   ```bash
   java -jar rars1_6.jar
   ```

### Step 2: Set Up and Execute
1. Open `s1103558.asm` in RARS.
2. Place your input bit strings into a file named `input.txt` and update the filename: line in `.data` section of the `.asm` file if needed:
```assembly
filename: .string "C:\\path\\to\\input.txt"
```
3. Assemble the program (`F3`) and Run (`F5`).

---

## Sample Output
For each 32-bit binary string:
- The binary string is printed.
- Its decimal integer value.
- Its floating part (e.g., `-1.1920929E-7`).
- Its exponent part (e.g., `2^-126`).
- The full decimal floating-point result.

Special cases:
- If the binary represents NaN:
  ```
  This is not a number: NaN
  ```
- If the binary represents Infinity:
  ```
  This is infinity
  ```
  
---
  
## Notes
- The project makes use of RISC-V floating-point instructions (`fadd.s`, `fmul.s`, etc.).
- Floating-point formatting uses `fmv.x.s` and `fmv.s.x` for printing.
- The program includes a `pow2_float` subroutine to compute 2^exponent using float math.

---

## Related Tools
- RARS Github [https://github.com/TheThirdOne/rars]
- IEEE 754 Specification [https://en.wikipedia.org/wiki/IEEE_754]
