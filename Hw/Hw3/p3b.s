    .text
    .globl strrchr

strrchr:
    andi    a1, a1, 0xFF        -- store lower 8 of target 
    mv      t0, zero          -- reset match storage   

scan_loop:
    lbu     t1, 0(a0)        -- get current character    
    bne     t1, a1, check_end   -- compare to target
    mv      t0, a0    -- copy match location            
check_end:
    beqz    t1, scan_done        -- check for null
    addi    a0, a0, 1         -- increment index    
    j       scan_loop   -- jump back to start of loop

scan_done:
    mv      a0, t0       -- store match location       
    ret         -- return