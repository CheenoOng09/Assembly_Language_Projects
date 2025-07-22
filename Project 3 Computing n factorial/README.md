# Project 3: Computing n Factorial

This project demonstrates the implementation of a RISC-V assembly program using the [Jupiter RISC-V simulator](https://github.com/andrescv/Jupiter). The program takes user input for a non-negative integer and calculates its factorial (`n!`). It also counts the number of instructions executed during the computation.

---

## Problem Description

You are required to modify the RISC-V code from page 44 of the course lecture slides to compute `n!` repetitively for different values of `n`. Additionally, the program must count and display the total number of instructions executed. Input and output must follow the format shown in the example output provided in the assignment.

This implementation uses the Jupiter simulator which supports RISC-V ISA (I, F, M extensions) and supports keyboard I/O via ECALLs.

---

## Features

- Accepts user input for name and student ID
- Prompts for non-negative integers until a negative number is entered
- Computes factorial using recursion
- Counts the number of RISC-V instructions executed per computation
- Displays results in a clearly formatted output

---

## File Structure

```
Project 3 Computing n factorial/
├── s1103558.s          # Assembly source code
├── Computing n factorial.pdf   # Problem statement
├── s1103558.pdf        # Screenshot of correct output 
```

---

## How to Run

### Requirements

- **Jupiter RISC-V Simulator**  
  Download here: [https://github.com/andrescv/Jupiter](https://github.com/andrescv/Jupiter)

### Steps

1. Open **Jupiter** by running `Jupiter.bat` on Windows.
2. Load the assembly file `s1103558.s`.
3. Click **Assemble** and then **Run** the program.
4. Follow the instructions in the terminal:
   - Enter your **name**
   - Enter your **student ID**
   - Enter a **non-negative number** to compute its factorial
   - Enter `-1` or any **negative number** to exit the program

---

## Sample Output

The screenshot showing correct output for multiple test cases is available in the file: `s1103558.pdf`

---

---

## 🔗 References

- [Jupiter Simulator GitHub](https://github.com/andrescv/Jupiter)
- [Jupiter Simulator Docs](https://jupitersim.gitbook.io/jupiter/)
- [Example Fibonacci Code](https://github.com/andrescv/Jupiter/blob/main/examples/fibonacci.s)

---
