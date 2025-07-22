# Project 1: Bubble Sort (Jupiter Assembler)

This project implements the **Bubble Sort** algorithm using **RISC-V assembly** and is executed via the [Jupiter Assembler](https://github.com/andrescv/jupiter). The program reads a number of integers from the user, sorts them in ascending order using bubble sort, and then displays the sorted result.

---

## 📘 Problem Description

Translate the following C++ code into RISC-V assembly code using Jupiter:

```cpp
void bubbleSort(int v[], size_t n) {
    size_t i, j;
    for (i = 0; i < n; i++) {
        for (j = i - 1; j >= 0 && v[j] > v[j + 1]; j--) {
            swap(v, j);
        }
    }
}

void swap(int v[], int k) {
    int temp = v[k];
    v[k] = v[k + 1];
    v[k + 1] = temp;
}

int main() {
    int numInt;
    int anAry[256];
    cin >> numInt;
    for (int i = 0; i < numInt; i++)
        cin >> anAry[i];
    bubbleSort(anAry, numInt);
    return 0;
}
```

## 🛠️ How to Run

1. Download and launch [Jupiter Assembler](https://github.com/andrescv/jupiter).
2. Open the file: `s1103558.s`
3. Run the program and follow the console prompts:
   - Enter the number of integers
   - Input each integer one by one
4. The program will output the sorted integers.

> Input must be entered one value per line due to Jupiter's constraints.

---

## Files Included

| File Name              | Description                            |
|------------------------|----------------------------------------|
| `s1103558.s`           | Main assembly code                     |
| `s1103558.pdf`         | Output screenshot (not included here)  |
| `Project 1 Bubble Sort.pdf` | Problem description and requirements |

---

## Features

- Fully commented RISC-V assembly code
- Implements classic bubble sort
- Uses memory addressing for array access
- Shows usage of `.data`, `.rodata`, and `.text` segments
- Demonstrates ECALLs for input/output

---

## Output Example

(See `s1103558.pdf` for full screenshot output.)

---

## References

- Jupiter Docs: [ECALLs](https://jupitersim.gitbook.io/jupiter/assembler/ecalls)
- Jupiter Docs: [Directives](https://jupitersim.gitbook.io/jupiter/assembler/directives)
- RISC-V Assembly Manual: [riscv-asm](https://github.com/riscv-non-isa/riscv-asm-manual)
