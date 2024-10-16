.data
test:
    .word 0x40490FD0       # 3.14159
    .word 0x3FCF1AA0       # 1.618
    .word 0xC2F6E979       # -123.456 

test_bf16_output:
    .half 0x0           # converted bfloat16 values
    .half 0x0
    .half 0x0

test_output:
    .word 0x0       # converted float32 recovered values
    .word 0x0
    .word 0x0

.text
.global main
main:
    # Initialize loop counter
    la s0, test
    la s1, test_bf16_output
    la s2, test_output
    li s3, 0               # i = 0
    li s4, 3               # num = 3 (size of the test_data array)
    li s5, 0xffff0000

loop:
    bge s3, s4, end_loop   # if i >= num, exit loop
    lw a0, 0(s0)           # Load float value (FP32) into a0    
    li a7, 2
    ecall
    
    jal ra, fp32_to_bf16   # Call function
    li a7, 34
    ecall
    
    jal ra, bf16_to_fp32
    li a7, 2
    ecall   

    # Load test_data[i+1]
    addi s0, s0, 4         # Address of test_data
    addi s1, s1, 2         # Address of test_bf16_output
    addi s2, s2, 4         # Address of expected_fp32
    

    j next_iteration
    
fp32_to_bf16:

    li t0, 0x7fffffff      
    li t6, 0
    and t1, t6, t0         
    li t0, 0x7f800000      
    bgt t1, t0, handle_nan 
_1:

    li t0, 0x7fff          
    srli t1, a0, 16        
    andi t1, t1, 1         
    add t1, t1, t0         
    add t1, t1, a0         
    srli t1, t1, 16        
    mv a0, t1
    sh a0, (0)s1              
    ret                    

handle_nan:
    srli t1, a0, 16         
    ori t1, t1, 64        
    mv a0, t1              
    j _1          

   
bf16_to_fp32:
# a0 contains the input bf16 (h.bits)     
    slli t0, a0, 16      
    mv a0, t0
    sw a0, (0)s2
    ret

next_iteration:
    addi s3, s3, 1         # i++
    j loop                 # Go to the next iteration

end_loop:
    li a7, 10
    li a0, 0
    ecall