lw R0, R1, 1000
lw R0, R2, 500
lw R0, R5, 501
LOOP:  add R4, R2, R4
       lw R4, R6, 1000
       slt R1, R6, R7
       beq R7, R0, IF
       add R6, R0, R1
IF:    bne R4, R5, LOOP