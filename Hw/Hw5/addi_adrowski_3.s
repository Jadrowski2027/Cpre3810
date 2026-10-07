# addi_adrowski_3.s
# Test 3: Arithmetic edge cases (carries, borrows, crossing zero, wraparound)
#
# Test 1 checked that the immediate arrives correctly. This test checks
# that the adder produces the right 32-bit sum: carries and borrows
# ripple through bit 11 and beyond, signs flip correctly, and results
# outside the 12-bit immediate range come out at full width. addi never
# raises an overflow exception; it just wraps around. Only addi is used.
#
# Note on signed overflow: an actual 0x7FFFFFFF + 1 case needs a register
# holding 0x7FFFFFFF. Building that with addi alone would take about
# a million instructions (lui/add come after addi on the list, so they
# can't be used). Instead, the wraparound case 0xFFFFFFFF + 1 sends a
# carry through all 32 adder bits and drops the carry out, which
# exercises the full adder width.

.data

.text
.globl main

main:

    # Start Test

    addi x1, x0, -1        # x1 = 0xFFFFFFFF
    addi x1, x1, 1         # x1 = 0x00000000. Carry ripples through all 32 bits and the
                           # carry out is dropped. Checks wraparound with no trap and
                           # catches a broken bit anywhere in the carry chain.

    addi x2, x0, 2047      # x2 = 0x000007FF
    addi x2, x2, 1         # x2 = 0x00000800 = 2048. Carry out of bit 10 into bit 11.
                           # The result must NOT be sign-extended (0xFFFFF800 would mean
                           # the result was wrongly treated as a 12-bit value).

    addi x3, x0, -2048     # x3 = 0xFFFFF800
    addi x3, x3, -1        # x3 = 0xFFFFF7FF = -2049. Borrow out of bit 11; result is
                           # just below the most negative immediate.

    addi x4, x0, 2047      # x4 = 2047
    addi x4, x4, 2047      # x4 = 4094 = 0x00000FFE. Largest sum of two maximum positive
                           # 12-bit values; needs bit 12 and above.

    addi x5, x0, -2048     # x5 = -2048
    addi x5, x5, -2048     # x5 = -4096 = 0xFFFFF000. Most negative sum of two minimum
                           # values; bits 11:0 become all zero.

    addi x6, x0, 5         # x6 = 5
    addi x6, x6, -10       # x6 = -5 = 0xFFFFFFFB. Positive + negative crossing zero
                           # into negative (the result's sign changes).

    addi x7, x0, -5        # x7 = -5
    addi x7, x7, 10        # x7 = 5 = 0x00000005. Negative + positive crossing zero
                           # into positive: all upper 1s must carry out to 0s.

    addi x8, x0, 100       # x8 = 100
    addi x8, x8, -100      # x8 = 0. Equal-magnitude opposite signs: the result must
                           # be exactly zero.

    addi x9, x0, 1365      # x9 = 0x00000555
    addi x9, x9, 1365      # x9 = 0x00000AAA = 2730. Doubling the alternating pattern
                           # shifts every set bit up one place, testing each bit's
                           # sum logic without a long carry chain.

    addi x10, x0, -1234    # x10 = -1234 = 0xFFFFFB2E
    addi x10, x10, 0       # x10 = -1234. Adding zero must leave a negative value
                           # unchanged (identity, like a register move).

    addi x11, x0, 2047     # x11 = 2047
    addi x11, x11, 2047    # x11 = 4094
    addi x11, x11, 2047    # x11 = 6141
    addi x11, x11, 2047    # x11 = 8188 = 0x00001FFC. Repeated accumulation grows
                           # the value well past the 12-bit range.

    addi x12, x0, -2048    # x12 = -2048
    addi x12, x12, -2048   # x12 = -4096
    addi x12, x12, -2048   # x12 = -6144
    addi x12, x12, -2048   # x12 = -8192 = 0xFFFFE000. Negative accumulation past the
                           # 12-bit range.

    addi x13, x0, -1       # x13 = 0xFFFFFFFF
    addi x13, x13, 2047    # x13 = 0x000007FE = 2046. -1 plus the largest positive
                           # immediate; the carry out of bit 31 is dropped and the
                           # result becomes positive.

  end:
    wfi
    j end
