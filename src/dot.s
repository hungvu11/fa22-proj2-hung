.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    ble a2, x0, loop_error1
    ble a3, x0, loop_error2
    ble a4, x0, loop_error2
    
    add t0, x0, x0 
    add t1, x0, x0
    add t2, x0, x0
    add a5, x0, x0
loop_start:
    beq t0, a2, loop_end
    slli t3, t1, 2
    slli t4, t2, 2
    add t3, t3, a0
    add t4, t4, a1
    lw t5, 0(t3)
    lw t6, 0(t4)
    mul t5, t5, t6
    add a5, a5, t5

    addi t0, t0, 1
    add t1, t1, a3
    add t2, t2, a4
    j loop_start
loop_end:


    # Epilogue
    add a0, a5, x0
    jr ra
loop_error1:
    li a0, 36
    j exit
loop_error2:
    li a0, 37
    j exit