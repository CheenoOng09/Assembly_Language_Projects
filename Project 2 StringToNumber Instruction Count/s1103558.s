#Student Name: Mikollito Ong
#Student ID Number: 1103558
.globl __start

.rodata

  msg1: .string "\nTotal number of instructions executed: " #########

  # open flags
  O_RDWR:  .word 0b0000001
  O_CREAT: .word 0b0100000
  O_EXCL:  .word 0b1000000
  # pathname
  pathR: .string "C:\\Users\\miko9\\Downloads\\HomeWork2Modified\\example4.txt"
.data
  readB: .zero 1024
  intData: .zero 1024

.text

__start:
  addi x17, x17, 0## x17 is where the instruction counter will start. Initialized at 0 
  li a0, 13      # ecall code
  la a1, pathR    # pathname address
  lw a2, O_RDWR  # load O_RDWR open flag
  lw t0, O_CREAT # load O_CREAT open flag
  or a2, a2, t0  # set a2 = O_RDWR | O_CREAT
  ecall          # Return file descriptor in a0
  mv a1, a0
  li a0, 1
  ecall
  mv t2, a1      #keep file descriptor in t2
  li a0, 14       # ecall code
  mv a1, t2       # file descriptor
  la a2, readB   # buffer address
  li a3, 300  # number of bytes to read
  ecall
  mv t3, a0  # store the number of bytes actually read in t3 (x28)
  li a0, 11
  li a1, ' '
  ecall
  li a0,1    #print the number of bytes actually read from a file
  mv a1, t3
  ecall
  mv t0, x0  #byte-index to the buffer
  addi x21, x0, 48 # digit 0
  addi x22, x0, 58 # > digit 9
  addi x23, x0, 45 # sign -
  addi x25, x0, 10 # constant 10
  la x26, intData # the base address for storing converted number
  mv x27, x0 # number of integers in the buffer
  mv x18, x0 #hold the value of the number
  mv x20, x0 #number starts
  addi x24, x0, 1 # defuat sign
  addi x17, x17, 32##THERE ARE 32 INSTRUCTIONS IN THIS BLOCK BEFORE THE BRANCH LABEL NAMED lp
  lp: 
  add t1, t0, a2 # byte addres to the buffer ReadB
  lbu  x19, 0(t1) #x19 keep the byte read from buffer readB
  addi t0, t0, 1 #increse the byte address to readB by 1
  addi x17, x17, 4## THERE ARE 4 INSTRUCTIONS IN THIS BLOCK. THE BRANCH CONDITION BELOW IN INCLUDED IN THE COUNTING
  bltu x19, x21,nextB
  addi x17, x17, 1## BRANCH CONDITION BELOW IS COUNTED
  bgeu x19, x22,nextB
  addi x17, x17, 1## ANOTHER BRANCH CONDITION IS COUNTED 
  bne  x20, x0, restDit #not the first digit of an integer 
  addi x20, x0, 1  # the first digit of a number. Set the start flag to true
  addi x17, x17, 1## ADDING THE ADD IMMEDIATE INSTRUCTION AT LINE 66 TO THE COUNTER
  restDit:   
  addi x19, x19, -48 #get the digit value
  mul  x18, x18, x25 #multiplied by 10
  add  x18, x18, x19 # adding digit value
  addi x17, x17, 4## ADDING 4 INSTRUCTIONS IN THE COUNTER INCLUDING THE BRANCH CONDITION
  bne  t3, t0, lp
  nextB: 
  addi x17, x17, 1## ADDING 1 INSTRUCTION IN THE COUNTER BECAUSE OF THE BRANCH CONDITION BELOW
  beq   x19, x23, negativeN # negative sign -
  addi x17, x17, 1## ADDING 1 INSTRUCTION IN THE COUNTER BECAUSE OF THE BRANCH CONDITION BELOW
  bne   x20, x0, endNum # get a space or a \n, so come to the end of a number if x20 == 1 
  addi x17, x17, 1## ADDING 1 INSTRUCTION IN THE COUNTER BECAUSE OF THE BRANCH CONDITION BELOW
  bne   t3, t0, lp  #process next bbyte in readB
  # get a number completely if x20=1. If x20!= 1, this meaans we did not get a number.
  # This occurs when the data is ended with a sequence of space characters
  endNum:
  addi x17, x17, 1## ADDING 1 INSTRUCTION IN THE COUNTER BECAUSE OF THE BRANCH CONDITION BELOW
  beq   x20, x0, StopE
  slli  x29, x27, 2 # offset to intData
  add   x29, x29, x26 # address for storing the number
  mul   x18, x18, x24 # set the sign of the number being stored
  sw    x18, 0(x29) #store word into 
  addi  x27, x27, 1 # increase the number processed by 1
  mv    x18, x0 #hold the value of the number
  mv    x20, x0 #number starts
  addi  x24, x0, 1 # defuat sign: positive
  addi x17, x17, 9## ADDING 9 INSTRUCTIONS TO THE COUNTER FROM LINE 84 TO 94
  bne   t3, t0, lp
  addi x17, x17, 1## ADDING 1 INSTRUCTION IN THE COUNTER BECAUSE OF THE BRANCH CONDITION BELOW
  beq   x0, x0, StopE   # added by RB
  
  negativeN: 
  addi x24, x0, -1 # set to negative sign 
  addi x17, x17, 2## ADDING 2 INSTRUCTIONS TO THE COUNTER  INCLUDING THE BRANCH CONDITION BELOW
  bne  t3, t0, lp
  StopE:
  li   a0, 11
  li   a1, '\n'
  ecall
  #x26: base address for the buffer 
  #x27: number of integers in the buffer
  #t2: file descriptor
  #print out the number store in the buffer intData
  mv    a1, x27
  li    a0, 1
  ecall
  mv    x21, x0 #index into the buffer
  li   a0, 11
  li   a1, ' '
  ecall
  addi x17, x17, 11## ADDING 11 INSTRUCTIONS TO THE COUNTER INCLUDING THE BRANCH CONDITION BELOW
  beq   x27, x0, endE # print numbers if there is any
  printNum: 
  slli  x22, x21, 2 #offset to the base address of intData
  add   x22, x22, x26 # address of the number being printed
  lw    a1, 0(x22)
  li    a0, 1
  ecall
  addi x21, x21, 1
  li   a0, 11
  li   a1, ' '
  ecall
  addi x17, x17, 10## ADDING 10 INSTRUCTIONS TO THE COUNTER  INCLUDING THE BRANCH CONDITION BELOW
  bne x21, x27, printNum
  endE:
  addi x17, x17, 5## ADDED 5 TO THE COUNTER TO ENSURE IT EXECUTES BEFORE THE PROGRAM FINISHES
  li a0, 16 # ecall code, close file
  mv a1, t2  # file descriptor
  ecall
  li a0, 4 # ecall code 
  la a1, msg1                                 # string to print
  ecall                                     #####
  li a0, 1                                   # ecall code
  add a1, x0 x17                                 # integer to print
  ecall
  li a0, 10
  ecall