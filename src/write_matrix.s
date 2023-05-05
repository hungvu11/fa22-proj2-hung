.data
.align 4
row: .word 1 2

.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    
    mv s2, a1   # pointer to the matrix in memory
    mul s3, a2, a3  # size of the matrix
    
    # open file with write permissions
    li a1, 1
    jal ra, fopen
    li t0, -1
    beq a0, t0, error_fopen
    
    mv s0, a0  # file descriptor
        
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, -16
    
    la s1, row   
    sw a2, 0(s1)
    sw a3, 4(s1)
    
    addi sp, sp, 16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    
    mv a0, s0
    mv a1, s1
    li a2, 2    # write 2 number 
    li a3, 4    # each number has size 4
    jal ra, fwrite
    li t0, 2
    bne a0, t0, error_fwrite
    
    # fwrite the matrix in the file
    mv a0, s0
    mv a1, s2
    mv a2, s3
    li a3, 4
    jal ra, fwrite
    bne a0, s3, error_fwrite
    
    mv a0, s0
    jal ra, fclose
    bne a0, x0, error_fclose
    
    # Epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, 16
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    
    jr ra
error_fopen:
    li a0, 27
    j exit
error_fwrite:
    li a0, 30
    j exit
error_fclose:
    li a0, 28
    j exit