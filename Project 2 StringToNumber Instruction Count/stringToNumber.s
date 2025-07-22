# This program is called StringToNumber. The program will read a number of bytes from a file.
# The file nume is specified by the string after the label pathR. The program will at most read 100
# bytes of data from the file and strore the data in the memory region whose starting address is 
# specified by the label readB (called memory region readB). The program then processes the data
# in the memory region readB byte by byte to convert the data into decimal numbers which are
# stored in the memory reagion intData.  It then prints the decimal numbers on a monitor.

.globl __start

.rodata
  # open flags
  O_RDWR:  .word 0b0000001
  O_CREAT: .word 0b0100000
  O_EXCL:  .word 0b1000000
  # pathname
  pathR: .string "D:\\RISC-V\\HomeWork1\\example.txt"
.data
  readB: .zero 1024
  intData: .zero 1024

.text

__start:
  li a0, 13      # ecall code
  la a1, pathR    # pathname address
  lw a2, O_RDWR  # load O_RDWR open flag
  lw t0, O_CREAT # load O_CREAT open flag
  or a2, a2, t0  # set a2 = O_RDWR | O_CREAT
  ecall  # Return file descriptor in a0
  mv a1, a0
  li a0, 1
  ecall
  mv t2, a1  #keep file descriptor in t2
  li a0, 14   # ecall code
  mv a1, t2    # file descriptor
  la a2, readB # buffer address
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
  lp: 
  add t1, t0, a2 # byte addres to the buffer ReadB
  lbu  x19, 0(t1) #x19 keep the byte read from buffer readB
  addi t0, t0, 1 #increse the byte address to readB by 1
  bltu x19, x21,nextB
  bgeu x19, x22,nextB
  bne  x20, x0, restDit #not the first digit of an integer 
  addi x20, x0, 1  # the first digit of a number. Set the start flag to true
  restDit:   
  addi x19, x19, -48 #get the digit value
  mul  x18, x18, x25 #multiplied by 10
  add  x18, x18, x19 # adding digit value
  bne  t3, t0, lp
  nextB: 
  beq   x19, x23, negativeN # negative sign -
  bne   x20, x0, endNum # get a space or a \n, so come to the end of a number if x20 == 1 
  bne   t3, t0, lp  #process next bbyte in readB
  # get a number completely if x20=1. If x20!= 1, this meaans we did not get a number.
  # This occurs when the data is ended with a sequence of space characters
  endNum:
  beq   x20, x0, StopE
  slli  x29, x27, 2 # offset to intData
  add   x29, x29, x26 # address for storing the number
  mul   x18, x18, x24 # set the sign of the number being stored
  sw    x18, 0(x29) #store word into 
  addi  x27, x27, 1 # increase the number processed by 1
  mv    x18, x0 #hold the value of the number
  mv    x20, x0 #number starts
  addi  x24, x0, 1 # defuat sign: positive
  bne   t3, t0, lp
  beq   x0, x0, StopE   # added by RB
  negativeN: 
  addi x24, x0, -1 # set to negative sign 
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
  bne x21, x27, printNum
  endE:
  li a0, 16 # ecall code, close file
  mv a1, t2  # file descriptor
  ecall
  li a0, 10
  ecall