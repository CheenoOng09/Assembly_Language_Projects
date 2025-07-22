###############################################################################
#Title: N Factorial Function
#Name: Mikollito Ong
#Student ID Number: 1103558
#(a). How many hours did you spend for this homework?
#ANS: 13 hours
#(b). Who has helped you solve the coding problems?
#ANS: None
#(c). Did you copy someone's code?
#ANS: No
###############################################################################

.globl __start

.data
  nameBuffer:     .space 100       # Space to store name
  idBuffer:       .space 100       # Space to store student ID

  promptName:        .string "Please enter your name (in English): "
  promptNameResult:  .string "My name: "
  promptID:          .string "Please enter your student ID number (a string): "
  promptIDResult:    .string "My student ID number: "

  prompt:      .string "Please enter a non-negative number (a negative one for exit): "
  msg_result:  .string "The result of "
  msg_resultA: .string "!: "
  msg_count:   .string "The total number of instructions executed: "
  newline:     .string "\n"

.text

__start:
  li t5, 0             # Reset instruction counter

#First Prompt (Name)
  li a0, 4             # a0 = 4 to print string
  la a1, promptName    # promptName: "Please enter your name (in English): "
  ecall
#First Prompt User Input (Name)
  li a0, 8             # a0 = 8 to read input
  la a1, nameBuffer    # nameBuffer will hold the string input name
  li a2, 100
  ecall

#Print Name
  li a0, 4                    # a0 = 4 to print string
  la a1, promptNameResult     #promptNameResult: "My name: "
  ecall

  li a0, 4                    # a0 = 4 to print string
  la a1, nameBuffer           # User Input Name
  ecall

#Second Prompt (Student ID)
  li a0, 4                    # a0 = 4 to print string
  la a1, promptID             # promptID = "Please enter your student ID number (a string): "
  ecall

  li a0, 8                    # a0 = 8 to read input
  la a1, idBuffer             # idBuffer will hold the student ID number.
  li a2, 100
  ecall

#Print Second Prompt User Input (Student ID)
  li a0, 4                    # a0 = 4 to print string
  la a1, promptIDResult       # promptIDResult = "My student ID number: "
  ecall

  li a0, 4                    # a0 = 4 to print string
  la a1, idBuffer             # print the Student ID Number from the user input stored in idBuffer
  ecall

#This part is for reading user input integer and calling the factorial function 
read_loop:
  li a0, 4             # a0 = 4 to print string
  la a1, prompt        # Prompt: "Please enter a non-negative number (a negative one for exit): "
  ecall

  li a0, 5             # a0 = 5 to read integer
  ecall
  mv a2, a0            # Save input in a2

  blt a2, x0, exit     # Exit if input is negative

  mv a0, a2            # Copy input into a0
  jal x1, fact         # Call factorial function
  mv a3, a0            # Now a3 holds the factorial result from a0

# Print the result of N! 
# a2 holds the original N value
# a0 holds the result of N! 

  li a0, 4             # a0 = 4 to print string
  la a1, msg_result    # msg_result = "The result of "
  ecall

  li a0, 1             # a0 = 1 to print integer
  mv a1, a2            # Copy the content from a2 (user input) to a1 since the print function takes a1 as the argument
  ecall

  li a0, 4             # a0 = 4 to print string
  la a1, msg_resultA   # msg_resultA = "!: "
  ecall


  li a0, 1             # a0 = 1 to print integer
  mv a1, a3            # Print factorial result copied from a3 into a1
  ecall

#Print Instruction Count
  
  li a0, 4             # a0 = 4 to print string
  la a1, newline       # print \n
  ecall

  li a0, 4             # a0 = 4 to print string
  la a1, msg_count     # msg_count = "The total number of instructions executed: "
  ecall

  li a0, 1             # a0 = 1 to print integer
  mv a1, t5            # copy the number of instructions from t5 into a1. (print function will display the instruction count from a1)
  ecall

#Reset Instruction Counter
  li t5, 0

  li a0, 4
  la a1, newline
  ecall

  j read_loop

exit:
  li a0, 10
  ecall

# This code is for the Factorial Function
# The input N is stored in a0
# The value of N! is returned in a0
fact:
  addi sp, sp, -8    # Allocate 8 bytes of space in stack
  sw x1, 4(sp)       # Stores the return address onto the stack
  sw x10, 0(sp)      # Stores the initial value of N from a0 or x10 in the stack

  addi x5, x10, -1   # x5 = n-1
  addi t5, t5, 5     # Add 5 in the instruction count
  bge x5, x0, L1     # Branch to L1 if x5 >= 0 or N >= 0
  #bne x10, x0, L1    # If x10 != 0, Go to L1.

  addi x10, x0, 1    # Else, x10 = 1
  addi sp, sp, 8     # Move the stack pointer up by 8 bytes
  addi t5, t5, 3     # Add 3 in the instruction count
  jalr x0, 0(x1)     # return to the function caller

L1: 
  addi x10, x10, -1  # N = N - 1
  addi t5, t5, 2     # Add 2 in the instruction count
  jal x1, fact       # Call factorial (N-1)

RA: 
  addi x6, x10, 0
  lw x10, 0(sp)      # restore n from stack
  lw x1, 4(sp)       # restore return address from stack
  addi sp, sp, 8     # pop stack
  mul x10, x10, x6 
  addi t5, t5, 6     # Add 6 in the instruction count
  jalr x0, 0(x1)     # return
