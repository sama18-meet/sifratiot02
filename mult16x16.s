# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
main:   # Load data from memory
		la      t3, a
        lw      t3, 0(t3)
        la      t4, b
        lw      t4, 0(t4)
        
        # t6 will contain the result
        add		t6, x0, x0

        # Mask for 16x8=24 multiply
        ori		t0, x0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        
####################
# Start of your code

# Use the code below for 16x8 multiplication
#   mul		<PROD>, <FACTOR1>, <FACTOR2>
#   and		<PROD>, <PROD>, t0

# Get 0xFE from b=0xFEED
srli t1, t4, 8

# Multiply b[7,15] * a[0,15] = t6[0,23]
mul		t6, t3, t1
and		t6, t6, t0

# shift t6 by 8 bits
slli	t6, t6, 8

# Get 0xED from b=0xFEED
slli t1, t1, 8 # t1 = 0xFE00
sub t1, t4, t1  # t1 = 0xFEED - 0xFE00 = 0xED


# Multiply 0xED * a[0,15] = t5[0,23]
mul		t5, t3, t1
and		t5, t5, t0

# Adding the two multiplications
add t6, t6, t5

# End of your code
####################
		
finish: addi    a0, x0, 1
        addi    a1, t6, 0
        ecall # print integer ecall
        addi    a0, x0, 10
        ecall # terminate ecall


