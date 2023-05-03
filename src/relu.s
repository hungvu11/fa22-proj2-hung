.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    add t0, a0, x0
    add t1, a1, x0

loop_start:
    blt x0, t1, loop_continue
    li a0 36
    j exit
loop_continue:
    beq t1, x0, loop_end
    addi t1, t1, -1
    slli t2, t1, 2
    add t2, t2, t0
    lw t3, 0(t2)
    bge t3, zero, loop_continue
    sw x0, 0(t2)
    j loop_continue
loop_end:
    # Epilogue


    jr ra

    