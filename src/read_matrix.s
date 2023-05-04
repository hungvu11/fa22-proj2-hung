.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

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
    
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    mv s0, a0
    
    # using fopen to open file
    mv a0, s0
    li a1, 0
    jal ra, fopen
    li t0, -1
    mv s3, a0 # store the file desciptor
    
    beq s3, t0, error_27 # fopen returns an error
        
    li a0, 8
    jal ra, malloc
    add s1, x0, a0
    beq s1, x0, error_26
    
    # read number of rows and columns
    mv a0, s3
    mv a1, s1
    li a2, 8
    jal ra, fread
    li t1, 8
    bne a0, t1, error_29  # fread does not read the correct number of bytes
    
    # calculate how much space to allocate
    ebreak
    lw s5, 0(s1)
    lw s6, 4(s1)
    mul s4, s5, s6
    slli s4, s4, 2
    
    mv a0, s4
    jal ra, malloc
    add s2, x0, a0
    beq s2, x0, error_26  # malloc returns an error
    
    mv a0, s3
    mv a1, s2
    mv a2, s4
    jal ra, fread
    bne a0, s4, error_29  # fread does not read the correct number of bytes
    
    mv a0, s3
    jal ra, fclose
    bne a0, x0, error_28  # fclose returns an error
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
    
    mv a0, s2
    sw s5, 0(a1)
    sw s6, 0(a2)
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    jr ra
error_26:
    li a0, 26
    j exit
error_27:
    li a0, 27
    j exit
error_28:
    li a0, 28
    j exit
error_29:
    li a0, 29
    j exit