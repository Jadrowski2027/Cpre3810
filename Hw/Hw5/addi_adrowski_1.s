# addi_adrowski_1.s
# Test 1: Immediate field decoding and sign extension
#
# addi takes a 12-bit signed immediate (range -2048 to 2047) that the
# hardware must sign-extend to 32 bits before it reaches the ALU. These
# cases target the immediate path: the boundary values, the sign bit
# (bit 11), and bit patterns that expose swapped or stuck immediate bits.
# Only addi is used, since it is the first instruction on the list.

.data

.text
.globl main

main:

    # Start Test

    addi x1, x0, 0         # x1 = 0x00000000. Zero immediate: the ALU must add nothing
                           # and the immediate generator must output all zeros.
    addi x2, x0, 1         # x2 = 0x00000001. Smallest positive immediate; checks that
                           # bit 0 of the immediate is routed correctly.
    addi x3, x0, 2047      # x3 = 0x000007FF. Largest positive immediate. Bit 11 is 0,
                           # so bits 31:12 must stay 0 (no false sign extension).
    addi x4, x0, -2048     # x4 = 0xFFFFF800. Most negative immediate. Only bit 11 (the
                           # sign bit) is set, so bits 31:12 must be filled with 1s.
                           # Common bug: zero-extending instead of sign-extending.
    addi x5, x0, -1        # x5 = 0xFFFFFFFF. All-ones immediate must sign-extend to
                           # all ones (the most common negative constant).
    addi x6, x0, 1024      # x6 = 0x00000400. Bit 10 is the highest non-sign bit.
                           # Catches an off-by-one in which bit is treated as the sign
                           # (e.g. sign-extending from bit 10 would give 0xFFFFFC00).
    addi x7, x0, -1024     # x7 = 0xFFFFFC00. Negative counterpart of x6: bits 11:10
                           # set, and the sign extension must start above bit 11.
    addi x8, x0, 1365      # x8 = 0x00000555. Alternating 0101... pattern in the
                           # immediate; any swapped or stuck-at bit changes the value.
    addi x9, x0, -1366     # x9 = 0xFFFFFAAA. Inverse 1010... pattern, which is also
                           # negative, so it checks the pattern AND sign extension.
    addi x10, x0, 2046     # x10 = 0x000007FE. Max positive with bit 0 cleared; with x3,
                           # catches bit 0 stuck at 1.

    # Same boundary immediates with a non-zero rs1, so the sign-extended
    # immediate must be added rather than just passed through to rd.
    addi x11, x5, 2047     # x11 = -1 + 2047 = 2046 = 0x000007FE. Negative register plus
                           # largest positive immediate.
    addi x12, x3, -2048    # x12 = 2047 + (-2048) = -1 = 0xFFFFFFFF. Positive register
                           # plus most negative immediate; correct only if the
                           # immediate's upper bits were sign-extended.
    addi x13, x4, -1       # x13 = -2048 + (-1) = -2049 = 0xFFFFF7FF. Two negatives:
                           # the result is below the immediate range, so it must not be
                           # truncated back to 12 bits.

  end:
    wfi
    j end
