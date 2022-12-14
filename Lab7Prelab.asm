.text
main:
  addi a0, a0, -8	# Initializes number 1
  addi a1, a1, 6	# Initialize number 2
  add s0, zero, zero	# Initialize s0 to 0
  add s1, zero, zero	# Initialize s1 to 0
  add s1, s1, a1	# Set s1 to number 2
  srai s1, s1, 15	# Set entire register to value of number 2's MSB
  bnez s1, multiplyneg	# If the MSB was 1 (number 2 is negative) go to multiplyneg

multiplypos:		# If number 2 is positive, loop through multiplypos
  addi a1, a1, -1	# Decrement number 2 by 1
  add  s0, s0, a0	# Add number 1 to s0
  bnez a1, multiplypos	# Repeat until a1 is zero
  add  a0, zero, s0	# Set a0 to multiplied result
  beqz a1, end		# If a1 is zero, end

multiplyneg:		# If number 2 is negative, loop through multiplyneg	
  addi a1, a1, 1	# Increment number 2 by 1
  add  s0, s0, a0	# Add number 1 to s0
  bnez a1, multiplyneg	# Repeat until a1 is zero
  addi a0, zero, -1	# Set a0 to -1
  xor s0, s0, a0	# Flip all the bits for two's complement
  addi s0, s0, 1	# Add one for two's complement
  
end:
  add  a0, zero, s0	# Set integer to print to the multipled result
  addi a7, a7, 1	# RARS ecall code for PrintInt
  ecall
