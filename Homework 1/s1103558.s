#Student ID: 1103558
#Student Name: Mikollito Ong

.globl __start
.rodata
  msg1: .string "Enter the number of integers for sorting: "
  msg2: .string "The sorted integers are as follows:  "

.data
ary: .zero 2000 # set up a buffer of 2000 bytes to hold the data read from the keyboard.

.text

__start:

begin:
  # prints msg1 for size of array
  li a0, 4          # Loads 4 into a0 which signals printing a message to the screen
  la a1, msg1       # Loads msg1 into the register to be printed
  ecall             # Calls the system to execute the above code
  # reads an int and moves it to register t2 for array size
  li a0, 5          # Loads 5 into a0 which signals accepting input from the keyboard 
  ecall             # Calls the system to execute the above code
  mv s1, a0         # Moves value input from keyboard to s1
  # s1 = numInt

  li t2, 0          # t2 = i and i = 0 for knowing when to stop accepting input
  la s0, ary        # s0 holds the address of ary
  # reads ints and moves them to the array
input:
  bge t2, s1, sort  # when i >= array size exit loop 
  li a0, 5          # Loads 5 into a0 which signals accepting input from the keyboard 
  ecall             # Calls the system to execute the above code
  mv t3, a0         # Move input from a0 to t3
  slli t5, t2, 2    # Calculate next address of array i * 2^2 or i * 4
  add t5, t5, s0    # add offset to array
  sw t3, 0(t5)      # Save input from t3 into array
  addi t2, t2, 1    # increment i
  j input 
sort:
  li t3, 0          # t3 will be i = 0
  j for1tst
for1tst:
  bge t3, s1, exit1 # if i is greater than the size of the array exit loop
  addi t4, t3, -1   # set t4 which is j to i-1
  j for2tst
for2tst:
  blt t4, zero, exit2
  slli t1, t4, 2    # multiple j by 4 to get next element offset into t1
  add t1, s0, t1    # offset array address with t1
  lw t5, 0(t1)      # load element from arr[j]
  lw t6, 4(t1)      # load element from arr[j + 1]
  bgt t5, t6, swap  # jump to label swap if [j] > [j+1]
  addi t4, t4, -1   # j--
  j for2tst
swap:
  slli t1, t4, 2    # calculate address j*4 
  add t1, s0, t1    # calculate offset
  lw t5, 0(t1)      # Load value at base address into t5
  lw t6, 4(t1)      # Load value at base address + 1 into t5
  sw t6, 0(t1)      # Store value at base address into t6
  sw t5, 4(t1)      # Store value at base address + 1 into t5, this completes the swap
  addi t4, t4, -1   # j--
  j for2tst
exit1:
  li a0, 4          # Loads 4 into a0 which signals printing a message to the screen
  la a1, msg2       # Loads msg2 into the register to be printed
  ecall
  li t1, 0          # initiate i to 0, for print  
  j print

exit2:
  addi t3, t3, 1       # i++
  j for1tst
  
print:
  # prints the values
  bge t1, s1, end
  slli t2, t1, 2
  la s0, ary
  add t2, t2, s0
  lw t3, 0(t2)
  li a0, 1
  add a1, x0, t3
  ecall
  # prints a space
  li a0, 11         # Loading 11 into a0 so we can print a space
  li a1, ' '        # Loading a space into a1 to be printed
  ecall             # Calls the system to execute the above code
  addi t1, t1, 1
  j print

end:
  li a0, 10         # Loads 10 into register a0 which means to exit the program successfully
  ecall             # Calls the system to execute the above code