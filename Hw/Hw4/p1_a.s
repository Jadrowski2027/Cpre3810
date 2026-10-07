# Most appropriate instruction format: I-type Instruction
# This is appropriate since cnt t0, t1 only includes 2
# register locations, which is characteristic of the I-type
# instruction


loop:
lb x7, 0(t0)
blt x7, x0, negative
addi t0, t0, 1
addi x6, x6, 1
j loop
negative:

# It's not included since it would be an I-type instruction, but it also writes 
# two registers. No RISC-V instructions can write to two instructions within
# one instruction

## this also wasn't included since the PC constantly gets re-evaluated within the loop,
## so the entire loop couldn't be programmed within one instruction from the PC
