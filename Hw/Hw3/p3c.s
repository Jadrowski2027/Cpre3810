    .data
str_htp:        .asciz "howdy there partner"
str_howdy:     .asciz "howdy"

msg1:          .asciz "\nTest 1: strrchr(\"howdy there partner\", 't')  
-- included 't' because it appears at the end of the string
msg2:          .asciz "\nTest 2: strrchr(\"howdy there partner\", 'q') 
-- included 'q' to see if it correctly returns a null
msg3:          .asciz "\nTest 3: strrchr(\"howdy\", '\\0')     
-- included null to see if it correctly points to the end of the string
sep_msg:       .asciz "  ->  \""
close_nl:      .asciz "\"\n"
not_found_msg: .asciz "NULL (character not found)\n"

    .text
    .globl main
main:
    li      a7, 4
    la      a0, msg1
    ecall
    la      a0, str_htp
    li      a1, 'o'
    jal     ra, strrchr
    jal     ra, print_result

    li      a7, 4
    la      a0, msg2
    ecall
    la      a0, str_htp
    li      a1, 'z'
    jal     ra, strrchr
    jal     ra, print_result

    li      a7, 4
    la      a0, msg3
    ecall
    la      a0, str_howdy
    li      a1, 0
    jal     ra, strrchr
    jal     ra, print_result

    li      a7, 10              
    ecall


print_result:
    beqz    a0, pr_null

    mv      t2, a0                
    li      a7, 34               
    ecall

    li      a7, 4
    la      a0, sep_msg
    ecall

    li      a7, 4
    mv      a0, t2
    ecall

    li      a7, 4
    la      a0, close_nl
    ecall
    ret

pr_null:
    li      a7, 4
    la      a0, not_found_msg
    ecall
    ret