.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    bge x0, a1, error
    bge x0, a2, error
    bge x0, a4, error
    bge x0, a5, error
    bne a2, a4, error

# Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    
    mv s0, a0 #   a0 (int*)  is the pointer to the start of m0
    mv s1, a1 #   a1 (int)   is the # of rows (height) of m0
    mv s2, a2 #   a2 (int)   is the # of columns (width) of m0
    mv s3, a3 #   a3 (int*)  is the pointer to the start of m1
    mv s4, a4 #   a4 (int)   is the # of rows (height) of m1
    mv s5, a5 #   a5 (int)   is the # of columns (width) of m1
    mv s6, a6 #   a6 (int*)  is the pointer to the the start of d
    
    li t0, 0 # load i == 0
outer_loop_start:
    beq t0, s1, outer_loop_end 
    li t1, 0 # load j == 0
    
inner_loop_start:
    beq t1, s5, inner_loop_end
    mul t2, t0, s2
    slli t2, t2, 2
    add a0, s0, t2 #   a0 (int*) is the pointer to the start of arr0
    slli t3, t1, 2
    add a1, s3, t3 #   a1 (int*) is the pointer to the start of arr1
    mv a2, s2      #   a2 (int)  is the number of elements to use
    li a3, 1       #   a3 (int)  is the stride of arr0
    mv a4, s5      #   a4 (int)  is the stride of arr1
    
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    jal ra, dot
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    
    # store the result of dot function to d[t0][t1]
    mul t2, t0, s5
    add t2, t2, t1
    slli t2, t2, 2
    add t2, t2, s6
    sw a0, 0(t2)
    
    addi t1, t1, 1 # increase t1 by 1
    j inner_loop_start
    
inner_loop_end:
    addi t0, t0, 1 # increase t0 by 1
    j outer_loop_start

outer_loop_end:

# Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32
    
    jr ra

error:
    li a0 38
    j exit