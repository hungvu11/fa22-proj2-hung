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
    
    mv s0, a1 # pointer to the maxtrix in memory
    mul s2, a2, a3   # size of the matrix
    
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    

# Open the file with write permissions
    mv a0, s0
    li a1, 1
    jal ra, fopen
    li t0, -1
    mv s1, a0 # file descriptor
    beq s1, t0, error_fopen
    
    la s3, row
    sw a2, 0(s3)
    sw a3, 4(s3)
    
    ebreak
    mv a0, s1
    mv a1, s3
    li a2, 2
    li a3, 4
    
    jal ra, fwrite
    li t0, 2
    bne a0, t0, error_fwrite
    
    mv a0, s1
    mv a1, s0
    mv a2, s2
    li a3, 4
    jal ra, fwrite
    bne s2, a0, error_fwrite
    
    mv a0, s1
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