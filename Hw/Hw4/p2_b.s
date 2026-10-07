# C code

# #include<stdio.h>
# int fib(int n) {
##    if (n==0) return 0;
##    if (n==1) return 1;
#     return fib(n-1) + fib(n-2);}

# int main (void) {
#   int N;
#   printf("How many nums in sequence?\n");
#   scanf("%d", &N);
##  if (N > 0)
#       printf("Fib = %d\n", fib(N-1));
#   return 0;}

# RISC-V Implementation
.data
prompt: .asciz "How many nums in sequence?\n"
result: .asciz "Fib = "
.text
    j main      # start at main
fib: 
    addi sp, sp, -16
    sw ra, 12(sp)

    # base case 1: N == 2 -> Fib = 1
    li t0, 2
    beq a0, t0, base1 
    # base case 2: N == 1 -> Fib = 0  
    li t1, 1
    beq a0, t1, base2

    # recursive case: fib(n-1) + fib(n-2)
    addi a0, a0, -1     # a0 = n-1 (argument for firstcall)
    addi t2, a0, -1     # t2 = n-1 (arg for 2nd call)
    sw t2, 4(sp)        # store n-2 to stack for 2nd call
    jal ra, fib         # jump back to top (a0 = fib(n-1)
    sw a0, 8(sp)        # save fib(n-1)
    lw a0, 4(sp)        # load a0 = n-2
    jal ra, fib         # new call where a0 = fib(n-2)
    lw t1, 8(sp)        # t1 = fib(n-1)
    add a0, t1, a0      # a0 = fib(n-1) + fib(n-2)
    j done
base1:
    li a0, 1
    j done
base2: 
    li a0, 0

done:
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
main:
    # printf(...prompt...);
    la a0, prompt   # a0 = address of the prompt string
    li a7, 4
    ecall

    # take user input (scanf("%d", &N);)
    li a7, 5
    ecall
    mv s0, a0   # N is saved in s0
    blez a0, exit

    # Fib = fib(N)
    mv a0, s0       # a0 (argument) is N
    jal ra, fib     # call fib with a0 = N
    mv s1, a0   # s1 = Fib

    # print("Fib = %d\n", Fib);
    la a0, result
    li a7, 4    # print out text
    ecall
    mv a0, s3
    li a7, 1    # print out integer
    ecall
    li a0, 10   # put '\n' in a0
    li a7, 11   # print character
    ecall

exit:
    li a7, 10
    ecall