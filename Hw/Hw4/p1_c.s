
# two-instruction sequence
lui t0, 0xFEED2
addi t0, t0, 0x050

# 4-5 instruction sequence
addi t0, x0, -17    # 0xFFFFFFEF
slli t0, t0, 12     # 0xFFFEF000
addi t0, t0, -736   # 0xFFFEF000 + 0xFFFFFD20 = 0xFFFEED20
slli t0, t0, 8
addi t0, t0, 80 