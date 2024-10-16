.data
    test_data1: .word 3, 2, 1
    test_data2: .word 1, 2
    test_data3: .word 2, 2, 3, 1   
    nums_len:   .word 3, 2, 4   # Length of the test data 1, 2 and 3


.text
.globl main
main:
    addi s2, s2, 3    
    la s0, test_data1
    la s1, nums_len
_1:    
    beqz s2, end
    jal ra, load_test_data
    li a7, 1  # once get result, output 
    ecall
    addi s2, s2, -1
    addi s0, s3, 0
    addi s1, s1, 4

    j _1
    
load_test_data:
    mv a0, s0          # Load address of nums into a0
    lw a1, (0)s1      # Load length of the array into a1
    li t0, 0             # Initialize distinct count
    li t1, 0            # To keep track of max1
    li t2, 0            
    li t3, 0            

find_max:
    beqz a1, check_result # If a1 (length) is 0, go to check result
    # Increment distinct count
    addi t0, t0, 1
    lw t4, 0(a0)         # Load current number into t4
    addi a0, a0, 4       # Move to the next element
    addi a1, a1, -1      # Decrement the length

    # Check if t4 is a new distinct maximum
    beq t4, t1, find_max # If t4 is max1, skip
    beq t4, t2, find_max 
    beq t4, t3, find_max 

    # Update the distinct max variables
    bge t4, t1, max_1
    bge t4, t2, max_2
    bge t4, t3, max_3
  
    j find_max           # Repeat for the next element

max_1:    
    mv t3, t2
    mv t2, t1
    mv t1, t4
    j find_max
    
max_2:
    mv t3, t2
    mv t2, t4
    j find_max
    
max_3:
    mv t3, t4
    j find_max


check_result:
    # Check distinct count
    li t5, 3
    bge t0, t5, return_max3 # If > 3 distinct max, return max3

    # If there are <3 distinct max values, return max
    mv s3, a0
    mv a0, t1
    ret 

return_max3:
    mv s3, a0
    mv a0, t3
    ret

end:    
    # Exit program
    li a7, 10            # Exit syscall
    ecall