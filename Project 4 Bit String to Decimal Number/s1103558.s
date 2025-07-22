###############################################################################
#Title: Bit String to Decimal Number
#Name: Mikollito Ong
#Student ID Number: 1103558
#(a). How many hours did you spend for this homework?
#ANS: Roughly 40 hours
#(b). Who has helped you solve the coding problems?
#ANS: None
#(c). Did you copy someone's code?
#ANS: No
###############################################################################
.globl __start

.data
  filename:  .string "C:\\Users\\miko9\\Downloads\\Assembly_HW2\\example2.txt"
  buffer:  .space 1024
  bit_buffer: .space 33   # 32 bits + null terminator
  msg_A:  .string "** The file descriptor number: "
  msg_B:  .string "The number of bytes read: "
  msg_C:  .string "The number of bit strings is: "
  msg_D:  .string "** Program terminated normally."
  newline: .string "\n" 
  space:   .string " "

.rodata
  O_RDONLY:  .word 0b0000001

.text

__start:
  # Open the file and get the file descriptor number
  li a0, 13            # Syscall code for opening a file
  la a1, filename      
  lw a2, O_RDONLY      # Read-only flag
  ecall
  mv s0, a0            # Store the file descriptor to s0

  # Print file descriptor number
  li a0, 4             # Print string syscall
  la a1, msg_A
  ecall
  
  li a0, 1             # Print integer syscall
  mv a1, s0            # File descriptor
  ecall
  
  li a0, 4
  la a1, newline
  ecall

####################################################################################

  # Read the file and get the number of bytes read
read_file:
  li a0, 14            # Syscall code for reading a file
  mv a1, s0            # File descriptor
  la a2, buffer        # Buffer to store the read data
  li a3, 1024          # Maximum number of bytes to read
  ecall

  # Store the number of bytes read
  mv s1, a0            # Save the number of bytes read

  # Print the number of bytes read
  li a0, 4
  la a1, msg_B
  ecall
  
  li a0, 1
  mv a1, s1
  ecall

  li a0, 4
  la a1, newline
  ecall

##############################################################################################

  # Initialize counters
  li t0, 0             # Bit string count
  li t1, 0             # Current bit length
  li t2, 0             # Temporary register to build the number
  la t5, bit_buffer    # Bit buffer pointer
  la t6, buffer        # Buffer pointer

  # Scan the buffer for 32-bit binary strings
scan_bits:
  lb t3, 0(t6)         # Load a single byte from the buffer
  beq t3, x0, end_scan # If null terminator, end the loop
  
  # Check if the character is a valid binary digit (0 or 1)
  li t4, 48            # ASCII for '0'
  li a4, 49            # ASCII for '1'
  beq t3, t4, is_binary  # branch to is_binary if '0'
  beq t3, a4, is_binary  # branch to is_binary if '1'
  
  # If not a binary digit, reset the current bit length
  li t1, 0
  li t2, 0
  la t5, bit_buffer    # Reset bit buffer pointer
  j next_char

is_binary:
  # Store the bit as a character in the bit buffer
  sb t3, 0(t5)
  addi t5, t5, 1

  # Print the bit immediately
  li a0, 11
  mv a1, t3
  ecall

  # Shift the number left by 1 bit
  slli t2, t2, 1
  
  # Add the current bit (0 or 1)
  beq t3, a4, add_one
  j count_bit

add_one:
  addi t2, t2, 1

count_bit:
  addi t1, t1, 1       # Increment the current bit length
  li t4, 32
  beq t1, t4, store_number 

  j next_char

store_number:
  # Null-terminate the bit buffer
  sb x0, 0(t5)

  # Print a space before the decimal value
  li a0, 4
  la a1, space
  ecall

  # Print the 32-bit number
  li a0, 1
  mv a1, t2
  ecall

  # Print a newline
  li a0, 4
  la a1, newline
  ecall

  # Increment the bit string count
  addi t0, t0, 1
  li t1, 0             # Reset the bit length counter
  li t2, 0             # Reset the current number
  la t5, bit_buffer    # Reset bit buffer pointer

next_char:
  addi t6, t6, 1       # Move to the next byte in the buffer
  j scan_bits

end_scan:
  # Print the bit string count
  li a0, 4
  la a1, msg_C
  ecall

  li a0, 1
  mv a1, t0            # Print the bit string count
  ecall

  li a0, 4
  la a1, newline
  ecall

  # Close the file
  li a0, 16            # Close file syscall
  mv a1, s0            # File descriptor
  ecall

exit:
  li a0, 4
  la a1, msg_D
  ecall
  
  li a0, 10            # Exit syscall
  ecall
