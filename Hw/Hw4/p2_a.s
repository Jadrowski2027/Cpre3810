### C-code

# #include<stdio.h>
# #include<stdlib.h>

# int main (void) {
    # int N, Fib, i;    // amount of nums in sequence, fibonacci number
    # int* arr; // array of nums
    # printf("How many nums in seq:");
    # scanf("%d", &N); // user input
    # arr = malloc(N*sizeof(int);
    # for (i = 0;i<N;i++) {
    ##  if(i>=2){
    #       arr[i] = arr[i-1] + arr[i-2];
    #   } else if (i==1){
    #       arr[i] = 1;
    #   } else if (i==0){
    #       arr[0] = 0;
    #   }
    #   Fib = arr[i];
    # }
    # free(arr)
    # return 0;
# }

# RISC-V implementation

.data
prompt: .asciz "How many nums in sequence?\n"
result: .asciz "Fib = "
.text
        
main:
    # printf(...prompt...);
    la a0, prompt   # a0 = address of the prompt string
    li a7, 4
    ecall

    # take user input (scanf("%d", &N);)
    li a7, 5
    ecall
    mv s0, a0   # N is saved in s0

    blez s0, exit   # if N == 0 -> nothing to compute, so exit

    # allocate memory on stack (PUSH!) for arr according to input N
    slli t0, s0, 2  # t0 = N*4 bytes
    # Align stack sp to multiple of 16 bytes to match RISC-V memory allocation convention
    addi t0, t0, 15 # adds number of bytes to >=16
    andi t0, t0, -16    # ands with FFFFFFF0 to eliminate any non 16-multiple amount of bytes

    mv s1, t0   # remember size to deallocate (POP!)
    sub sp, sp, t0  # allocate
    mv s2, sp   # s2 = base addr of arr

    li t6, 1 
    sw x0, 0(s2)    # set arr[0] directly to zero to skip if statements within for loop
    beq s0, t6, EqualsN     # N==1 -> arr[1] doesn't exits
    sq t6, 4(s2)    # set arr[1] directly to one to skip if statements within for loop

    li t2, 2    # have loop start at i = 2 if user input is at least 3 numbers          
    loop:
        bge t2, s0, EqualsN     
        slli t3, t2, 2  # t3 = i*4
        add t3, s2, t3  # t3 = &arr[i]
        lw t4, -4(t3)   # t4 = arr[i-1]
        lw t5, -8(t3)   # t4 = arr[i-2]
        add t4, t4, t5  # t4 = arr[i-1]+arr[i-2]
        sw t4, 0(t3)    # arr[i] = t4
        addi t2, t2, 1  # i++
        j loop          # jump back to start of loop
    EqualsN:
        # Fib = arr[N-1]
        addi t3, s0, -1 # t3 = N-1
        slli t3, t3, 2  # t3 = (N-1)*4
        add t3, t2, t3  # t3 = &arr[N-1]
        lw s3, 0(t3)

        # print("Fib = %d\n", Fib)
        la a0, result
        li a7, 4    # print out text
        ecall
        mv a0, s3
        li a7, 1    # print out integer
        ecall
        li a0, 10   # put '\n' in a0
        li a7, 11   # print character
        ecall

        # Pop memory
        add sp, sp, 1

exit:
    li a7, 10   # exit
    ecall
        