@CODE
check_pos:      PUSH  R0
                PUSH  R1
                
                LOAD  R0  [GB+POS_X]
                LOAD  R1  [GB+TARGET_X]
                 CMP  R0  R1
                 BEQ  x_stop
                 BLT  x_positive
                LOAD  R0  -1
                STOR  R0  [GB+MOTORDIRECTION0]
                 BRA  check_y

x_stop:         LOAD  R0  0
                STOR  R0  [GB+MOTORDIRECTION0]
                 BRA  check_y
                 
x_positive:     LOAD  R0  1                 
                STOR  R0  [GB+MOTORDIRECTION0]
                 BRA  check_y
                 
check_y:        LOAD  R0  [GB+POS_Y]
                LOAD  R1  [GB+TARGET_Y]
                 CMP  R0  R1
                 BEQ  y_stop
                 BLT  y_positive
                LOAD  R0  -1
                STOR  R0  [GB+MOTORDIRECTION1]
                 BRA  check_pos_r

y_stop:         LOAD  R0  0
                STOR  R0  [GB+MOTORDIRECTION1]
                 BRA  check_pos_r
                 
y_positive:     LOAD  R0  1                 
                STOR  R0  [GB+MOTORDIRECTION1]
                 BRA  check_pos_r

check_pos_r:    PULL  R1
                PULL  R0
                 RTS
@END