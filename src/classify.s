.data
.align 4
row: .word 1
column: .word 2

.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

# Prologue    
    li t0, 5
    bne a0, t0, error_command
    
    addi sp, sp, -42
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)
    
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    la s3, row     # address of number of rows
    la s4, column  # address of number of columns
    mv s8, a2
   # read matrix m0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
        
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    
    lw a0, 4(a1)
    mv a1, s3
    mv a2, s4
    jal ra, read_matrix
    mv s0, a0    # pointer to matrix m0
    lw t0, 0(s3) # number of rows in m0
    lw t1, 0(s4) # number of columns in m0
    
    #read matrix input
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
        
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    
    addi, sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    lw a0, 12(a1)
    mv a1, s3
    mv a2, s4
    jal ra, read_matrix
    mv s1, a0    # pointer to matrix input
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    
    lw t2, 0(s3) # number of rows in input
    lw t3, 0(s4) # number of columns in input
    
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
#     ebreak
    # calucate matmul(m0, input)
    mul a0, t0, t3
    slli a0, a0, 2
#     ebreak
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s2, a0   # pointer to matrix h = matmul(m0, input)
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)

    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    
    mv a0, s0
    mv a1, t0
    mv a2, t1
    mv a3, s1
    mv a4, t2
    mv a5, t3
    mv a6, s2
    # ebreak
    jal matmul
#     ebreak
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)

    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    
    mv a0, s2
    mul a1, t0, t3
    jal relu
    
    # read m1 matrix
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    addi sp, sp, 16
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
        
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    
    lw a0, 8(a1)
    mv a1, s3
    mv a2, s4
    jal ra, read_matrix
    mv s5, a0  # pointer to matrix m1
        
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    addi sp, sp, 16
    lw t4, 0(s3)  # number of rows in m1
    lw t5, 0(s4)  # number of columns in m1
    
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    # calculate o = matmul(m1, h)
    mul a0, t4, t3
    slli a0, a0, 2
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s6, a0    # pointer to matrix o = matmul(m1, h)
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    mv a0, s5
    mv a1, t4
    mv a2, t5
    mv a3, s2
    mv a4, t0
    mv a5, t3
    mv a6, s6
    jal matmul
    
    # write matrix o to the output file
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    addi sp, sp, 24
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    lw a0, 16(a1)
    mv a1, s6
    mv a2, t4
    mv a3, t3
    jal write_matrix
    
    # compute argmax(o)
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
#     ebreak
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
#     ebreak
    mv a0, s6
    mul a1, t4, t3
    jal ra, argmax
    mv s7, a0    # return value

#     ebreak
    bne s8, x0, classify_end
    
    # if a2 == 0 print 0\n
    mv a0, s7
    jal print_int
    
    li a0 '\n'
    jal print_char
    
classify_end:
# Epilogue
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    addi sp, sp, 24
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
    
    mv a0, s7
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 42
    
    jr ra


error_malloc:
    li a0, 26
    j exit
error_command:
    li a0, 31
    j exit