# and then clear to 0
and x9, x9, x0
li x9, 45
li x9, 0

# Reg 9 to 0x381
addi x9, x0, 0x381

#Reg 10 to 0x381
slli x10, x9, 4

# use x11 for what if x9 did NOT already have 0x381
#addi x11, x0, 0x3810 -- Doesn't work, 0x3810 too big for 12 bits

lui x11, 0x00004
addi x11, x11, -0x7F0
li x12, 0x3810


wfi
