.data
str1: .asciz "Please enter a number:\n"
str2: .asciz "Enter an array index1:\n"
str3: .asciz "Enter an array index2:\n"
str4: .asciz "Enter an array index3 (where to store the minimum):\n"
.align 2
vals: .word 25 1 4 10 381 42 100 60 0 12 25
.text
.globl main

main:
# Start program
addi s1, zero, 0 # s1 is ouput value
inputs:

### Get Integer 1
li a7, 4 # a7 = system call register, 4 = call to print string
la a0, str2
ecall
# Read some user input:
li a7, 5 # 5 = call to read an integer from the user
ecall # read index of array integer one

# Do some more stuff with inputs
slli a0, a0, 2  # a0 = byte offset = index1 * 4 (word = 4 bytes)
la s1, vals      # s1 = base address of vals
add s1, s1, a0   # s1 = &vals[index1]
lw s2, 0(s1)     # s2 = vals[index1]

### Get Integer 2
li a7, 4 # a7 = system call register, 4 = call to print string
la a0, str3
ecall
# Read some user input:
li a7, 5 # 5 = call to read an integer from the user
ecall # read index of integer two

# Do some more stuff with inputs
slli a0, a0, 2  
la s1, vals
add s1, s1, a0   # s1 = &vals[index2]
lw s3, 0(s1)     # s3 = vals[index2]

### Get Integer 3 
li a7, 4
la a0, str4
ecall
li a7, 5
ecall # read index of integer three

slli a0, a0, 2  
la s1, vals
add s1, s1, a0   # s1 = &vals[index3]
add t2, x0, s1 

# determine min(s2, s3)
add  t0, s2, s3
sub  t1, s2, s3
bge  t1, zero, abs_done
sub  t1, zero, t1     
abs_done:
sub  t0, t0, t1          
srai t0, t0, 1 

# write the min to vals[index3]
sw t0, 0(s1)

# Print output
li a7, 1
lw a0, 0(s1)
ecall

# Exit program
li a7, 10
ecall
