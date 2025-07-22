###############################################################################
#Title: Bit String to Single Precision Floating Number
#Name: Mikollito Ong
#Student ID Number: 1103558
#(a). How many hours did you spend for this homework?
#ANS: 35 hours
#(b). Who has helped you solve the coding problems?
#ANS: None
#(c). Did you copy someone's code?
#ANS: No
###############################################################################
.globl __start

.data
  filename:  .string "C:\\Users\\miko9\\Downloads\\Assembly\\aedb489812134236973a53ce895a342e.txt"
  buffer:  .space 1024
  bit_buffer: .space 33   # 32 bits + null terminator
  msg_A:  .string "** The file descriptor number: "
  msg_B:  .string "The number of bytes read: "
  msg_C:  .string "The number of bit strings is: "
  msg_D:  .string "** Program terminated normally."
  newline: .string "\n" 
  space:   .string " "
  msg_fp: .string "The floating part is: "
  msg_exp: .string "The exponent part is: 2 to the "
  msg_val: .string "The decimal value of the 32-bit string is: "
  msg_nan: .string "This is not a number: NaN\n"
  msg_inf: .string "This is infinity\n"

.text
__start:
  # Open the file and get the file descriptor number
  li a7, 1024            	# Syscall code for opening a file
  la a0, filename		# address for the file path
  li a1, 0      		# a1 = 0 means read only file
  ecall
  mv s0, a0            	# Store the file descriptor to s0

  # Print file descriptor number
  li a7, 4             	# Print string syscall
  la a0, msg_A		# "** The file descriptor number: "
  ecall
  
  li a7, 1             	# Print integer syscall
  mv a0, s0            	# File descriptor
  ecall
  
  li a7, 4
  la a0, newline
  ecall
  
##############################################################################################

  # Read the file and get the number of bytes read
read_file:
  li a7, 63            # Syscall code for reading a file
  mv a0, s0            # File descriptor
  la a1, buffer        # Buffer to store the read data
  li a2, 1024          # Maximum number of bytes to read
  ecall

  # Store the number of bytes read
  mv s1, a0	# Save the number of bytes read

  # Print the number of bytes read
  li a7, 4
  la a0, msg_B	# "The number of bytes read: "
  ecall
  
  li a7, 1
  mv a0, s1
  ecall

  li a7, 4
  la a0, newline
  ecall

##############################################################################################
  # Start building the string bits and decimal value
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
  li a7, 11
  mv a0, t3
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
  li a7, 4
  la a0, space
  ecall

  # Print the 32-bit number
  li a7, 1
  mv a0, t2
  ecall

  # Print a newline
  li a7, 4
  la a0, newline
  ecall
############################################################################
  mv s2, t2          # Move 32-bit value to s2 for float decoding
  addi sp, sp, -36       
  sw t1, 0(sp)
  sw t2, 4(sp)
  sw t5, 8(sp)
  sw t6, 12(sp)
  sw ra, 16(sp)
  sw t0, 20(sp)
  sw t3, 24(sp)
  sw t4, 28(sp)
  sw a4, 32(sp)

  jal ra, decode_ieee754
  
  lw a4, 32(sp)
  lw t4, 28(sp)
  lw t3, 24(sp)
  lw t0, 20(sp)
  lw ra, 16(sp)
  lw t6, 12(sp)
  lw t5, 8(sp)
  lw t2, 4(sp)
  lw t1, 0(sp) 
  addi sp, sp, 36        # Restore stack

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
  li a7, 4
  la a0, msg_C
  ecall

  li a7, 1
  mv a0, t0            # Print the bit string count
  ecall

  li a7, 4
  la a0, newline
  ecall

  # Close the file
  li a7, 57            # Close file syscall
  mv a0, s0            # File descriptor
  ecall

exit:
  li a7, 4
  la a0, msg_D
  ecall
  
  li a7, 93            # Exit syscall
  ecall
  
decode_ieee754:
  # Extract sign bit (bit 31)
  # Store it to T1
  # If t1 = 1 -> Positive
  # If t1 = -1 -> Negative
  srli t0, s2, 31        # extract sign bit into t0 (0 or 1)
  li t1, -2
  mul t1, t0, t1         # t1 = -2 x 0 = "0" or -2 x 1 = "-2"
  addi t1, t1, 1         # t1 = 1 or -1 → correct sign multiplier

  # Extract exponent (bits 23-30) 
  # Store it to T2
  slli t2, s2, 1
  srli t2, t2, 24		# t2 = exponent
	
  # Extract mantissa (bits 0-22)
  # Store it to T3
  li t4, 0x007FFFFF	# mask for 23 LSBs
  and t3, s2, t4		# extract mantissa
	
  # t1 = sign bit
  # t2 = exponent
  # t3 = mantissa
  # t4 = 2^23
  # t6 = t2 - 127 (Actual Exponent)
	
  # Check for NaN or Infinity (Exponent == 255)
  li t0, 255
  beq t2, t0, check_nan_or_inf

  # Check if denormalized (if exponent == 0)
  beq t2, x0, denormal_case 	# if exponent at T2 is 0, then its a denormalized number
  	
  # Floating part = 1 + mantissa / 2^23
  # In normal case, the output will look like: (+-1.xxxx)
normal_case:
  li t4, 8388608            # t4 = 8388608 or 2^23
  fcvt.s.w fa1, t3          # int t3 -> fa1 float(mantissa)
  fcvt.s.w fa2, t4          # int t4 -> fa2 float(2^23)
  fdiv.s fa1, fa1, fa2	 # mantissa = mantissa / 2^23

  li t5, 1
  fcvt.s.w fa3, t5          # float(1.0)
  fadd.s fa1, fa1, fa3      # fa1 = 1 + mantissa_fraction
  fcvt.s.w fa4, t1          # float(sign: +1 or -1)
  fmul.s fa1, fa1, fa4      # fa1 = signed float part
  
  # fa1 = mantissa(float)
  # fa2 = 2^23 (float)
  # fa3 = 1 (For 1.0)
  # fa1 = fa1 + fa3 (1.fraction)
  # fa4 = +1 or -1
  # fa1 = fa1 x fa4 (1.fraction x [+1 or -1] )

  # Print floating part
  li a7, 4
  la a0, msg_fp		# "The floating part is: "
  ecall

  fmv.x.s a0, fa1		# float → int
  fmv.s.x fa0, a0		# int → float
  li a7, 2
  ecall

  li a7, 4
  la a0, newline
  ecall

  # Calculate Exponent part: (exponent - 127)
  addi t6, t2, -127	# t6 = exponent - bias (127)
  li a7, 4		
  la a0, msg_exp		# "The exponent part is: 2 to the "
  ecall

  li a7, 1
  mv a0, t6
  ecall

  li a7, 4
  la a0, newline
  ecall

  # Decimal value = floating_part * 2^exponent
  # Compute 2^(exponent - 127)
  
    	# t1 = sign bit
	# t2 = exponent
	# t3 = mantissa
	# t4 = 2^23
	# t6 = exponent - 127 (bias)
	# fa2 = 2^23 (float)
	# fa1 = fa1 x fa4 (1.fraction x [+1 or -1] )
	  
  mv a0, t6

  addi sp, sp, -4
  sw ra, 0(sp)		# Save return address

  jal ra, pow2_float	# Results will reflect in fa2

  lw ra, 0(sp)		# Restore return address
  addi sp, sp, 4

  fmul.s fa1, fa1, fa2      # complete result

  # Print the final value
  li a7, 4
  la a0, msg_val		# "The decimal value of the bit string is: "
  ecall
  
  fmv.x.s a0, fa1		# float → int
  fmv.s.x fa0, a0		# int → float
  li a7, 2
  ecall
  
  li a7, 4
  la a0, newline
  ecall  
  ret
######################################################################################################
check_nan_or_inf:
  # Mantissa in t3 is 0 → Infinity, 1 → NaN
  bgt t3, x0, is_nan
  beq t3, x0, is_inf 
  ret

is_nan:
  li a7, 4
  la a0, msg_nan		# "This is not a number: NaN\n"
  ecall
  ret

is_inf:
  li a7,4
  la a0, msg_inf		# "This is infinity\n"
  ecall
  ret

#########################################################################################################

  # In denormal case, the output will look like: +-0.xxx
  # Floating part = mantissa / 2^23
denormal_case:
  li t4, 8388608		# t4 = 2^23
  fcvt.s.w fa1, t3	# Move and convert Mantissa to the floating register fa1 as a float format
  fcvt.s.w fa2, t4	# Move and convert exponent 2^23 to the floating point Register fa2 as a float format
  fdiv.s fa1, fa1, fa2	# fa1 = Mantissa / 2^23
  fcvt.s.w fa3, t1	# Move and convert sign bit (1 or -1) to fa3 as a float (1.0 or -1.0)
  fmul.s fa1, fa1, fa3  	# Apply sign

  # Print floating part
  li a7, 4
  la a0, msg_fp		# "The floating part is: "
  ecall

  fmv.x.s a0, fa1		# float → int
  fmv.s.x fa0, a0		# int → float
  li a7, 2
  ecall

  li a7, 4
  la a0, newline
  ecall

  # Exponent part for denormalized number is always fixed: 2^-126
  li a7, 4
  la a0, msg_exp  # "The exponent part is: "
  ecall

  li a7, 1
  li a0, -126	# Since denormalized numbers will always have -126 as exponent, just load -126 to a0
  ecall

  li a7, 4
  la a0, newline
  ecall

  # Multiply floating part by 2^(E-127)
  li a0, -126

  addi sp, sp, -4
  sw ra, 0(sp)		# Save return address

  jal ra, pow2_float	# Call the pow2_float function

  lw ra, 0(sp)		# Restore return address
  addi sp, sp, 4

  fmul.s fa1, fa1, fa2

  li a7, 4
  la a0, msg_val		# "The decimal value of the 32-bit string is: "
  ecall

  fmv.x.s a0, fa1   	# float → int
  fmv.s.x fa0, a0   	# int → float
  li a7, 2
  ecall

  li a7, 4
  la a0, newline
  ecall

  ret
############################################################################
  # Function: Compute float(2^n)
  # Input: a0 = int n
  # Output: fa2 = float(2^n)
pow2_float:
  # fa2 = 1.0
  li s3, 1
  fcvt.s.w fa2, s3

  # fa3 = 2.0
  li s4, 2
  fcvt.s.w fa3, s4

  blt a0, x0, pow_neg	# If exponent is between -1 and -126, 
			# then we have perform repeated division 
			# based on the value of the exponent

# Positive exponent
  mv s5, x0		# S5 Counter = 0
pow_loop_pos:
  beq s5, a0, pow_done	# If S5 == Exponent, The calculation is finished
  fmul.s fa2, fa2, fa3	# This code will keep multiplying by 2 and accumulating value until S5 == Exponent (value will increase)
  addi s5, s5, 1
  j pow_loop_pos

# Negative exponent
pow_neg:
  neg s6, a0		# S6 = Positive of the expoent, if exponent is -126, then it will become +126
  mv s5, x0		# S5 Counter = 0
pow_loop_neg:
  beq s5, s6, pow_done	# If S5 == Positive Exponent, the calculation is finished
  fdiv.s fa2, fa2, fa3	# This code will keep dividing by 2 until S5 == Exponent (value will decrease)
  addi s5, s5, 1
  j pow_loop_neg

pow_done:
  ret
