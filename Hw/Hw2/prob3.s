.data
str1: .asciz "Please enter a number:\n"
.align 2
vals: .word 25 1 4 10 381 42 100 60 0 12 25
.text
.globl main

main:
# Start program
addi s1, zero, 0 # s1 is ouput value
inputs:
# Request some user input:
li a7, 4
la a0, str1
ecall
# Read some user input:
li a7, 5
ecall

# Do something with input
slli  s0, a0, 5 # Self-check for students: What is this doing?

# Request some user input:
li a7, 4
la a0, str1
ecall
# Read some user input:
li a7, 5
ecall

# Do some more stuff with inputs
slli a0, a0, 2  # Self-check for students: What is this doing?
# Usually you would let the assembler to the heavy lifting by using: la s1, vals
lui s1, 0x10010
addi s1, s1, 24 # Self-check for students: Why is this 24?
add s1, s1, a0
lw s1, 0(s1)    # Self-check for students: Why might this cause an error durint runtime? What inputs caused it? How could you fix it?
add s1, s0, s1 # Self-check for students: After this instruction, what does s1 hold? (qualitatively not quantitatively)

# Print output
li a7, 1
addi a0, s1, 0
ecall
# Exit program
li a7, 10
ecall

