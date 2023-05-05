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
    li t0, 5
    bne a0, t0, error_command
    # Prologue
    
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)
    
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    lw s0, 4(a1)  # load pointer to filepath string of the first matrix m0
    lw s1, 8(a1)  # load pointer to filepath string of the second matrix m1
    lw s2, 12(a1) # load pointer to filepath string of the input matrix input
    lw s3, 16(a1) # load pointer to filepath string of the output file
    la s4, row
    la s5, column
    
    # Read pretrained m0
    mv a0, s0
    mv a1, s4
    mv a2, s5
    jal ra, read_matrix
    mv s6, a0     # pointer to matrix m0
    
    lw t0, 0(s4)  # load number of row m0
    lw t1, 0(s5)  # load number of column
    
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)

    # Read pretrained m1
    mv a0, s1
    mv a1, s4
    mv a2, s5
    jal ra, read_matrix
    mv s7, a0     # pointer to matrix m1
    lw t2, 0(s4)  # load number of row m1
    lw t3, 0(s5)  # load number of column
    
    addi sp, sp, -8
    sw t2, 0(sp)
    sw t3, 4(sp)

    # Read input matrix
    mv a0, s2
    mv a1, s4
    mv a2, s5
    jal ra, read_matrix
    mv s8, a0     # pointer to matrix input
    lw t4, 0(s4)  # load number of row input
    lw t5, 0(s5)  # load number of column input
    
    addi sp, sp, -8
    sw t4, 0(sp)
    sw t5, 4(sp)

    # Compute h = matmul(m0, input)
    addi sp, sp, 24
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    mul a0, t0, t5
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s0, a0  # pointer to h
    
    addi sp, sp, 24
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    mv a6, a0
    mv a0, s6
    mv a1, t0
    mv a2, t1
    mv a3, s7
    mv a4, t4
    mv a5, t5
    jal ra, matmul
    mv s9, a6  # pointer to h malmul of m1 and input
    # Compute h = relu(h)
    mv a0, s9
    jal ra, relu

    addi sp, sp, 24
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    # Compute o = matmul(m1, h)
    mul a0, t2, t5
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s1, a0

    addi sp, sp, 24
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    mv a6, a0
    mv a0, s7
    mv a1, t2
    mv a2, t3
    mv a3, s9
    mv a4, t0
    mv a5, t5
    jal ra, matmul
    mv s10, a6   # pointer to matrix o

    addi sp, sp, 24
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    # Write output matrix o
    mv a0, s3
    mv a1, s10
    mv a2, t2
    mv a3, t5
    jal ra, write_matrix

    addi sp, sp, 24
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    
    # Compute and return argmax(o)
    mv a0, s10
    mul a1, t2, t5
    jal ra, argmax
    mv s11, a0
    # If enabled, print argmax(o) and newline
    bne s11, x0, classify_end
    mv a0, s11
    jal print_int
    li a0, '\n'
    jal print_char
classify_end:
    mv a0, s0
    jal free
    mv a0, s1
    jal free
    
    
    addi sp, sp, 24
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    
    addi sp, sp, 12
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    
    mv a0, s11
    
    addi sp, sp, 52
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    
    jr ra

error_malloc:
    li a0, 26
    j exit
error_command:
    li a0, 31
    j exit