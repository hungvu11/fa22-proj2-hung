.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    add t0, a0, x0
    add t1, a1, x0
    add t4, x0, x0 # return index
    lw t5, 0(a0) # maximum value
loop_start:
    blt x0, a1, loop_continue
    li a0, 36
    j exit

loop_continue:
    beq t1, x0, loop_end
    addi t1, t1, -1 # t1 is the index
    slli t2, t1, 2
    add t2, t2, t0
    lw t3, 0(t2)  # load x[t1]
    blt t3, t5, loop_continue
    add t4, t1, x0
    add t5, t3, x0
    j loop_continue
loop_end:
    # Epilogue
    add a0, t4, x0
    jr ra
