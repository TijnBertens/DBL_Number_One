@CODE
check_pos:      PUSH  R0
                PUSH  R1
                
                LOAD  R0  [GB+POS_X]                ; Load current x position in R0
                LOAD  R1  [GB+TARGET_X]             ; Load target x position in R1
                 CMP  R0  R1                        ; if(current == target)
                 BEQ  x_stop                        ; then stop the motor.
                 BLT  x_positive                    ; else if(current < target) then move in positive direction.
                LOAD  R0  -1                        ; else move in negative direction.
                STOR  R0  [GB+MOTORDIRECTION0]
                 BRA  check_y                       ; Check the y position.

x_stop:         LOAD  R0  0                         ; Stop the motor.
                STOR  R0  [GB+MOTORDIRECTION0]
                 BRA  check_y
                 
x_positive:     LOAD  R0  1                         ; Move the motor in positive direction.
                STOR  R0  [GB+MOTORDIRECTION0]
                 BRA  check_y
                 
check_y:        LOAD  R0  [GB+POS_Y]                ; Load current y position in R0
                LOAD  R1  [GB+TARGET_Y]             ; Load target y position in R1
                 CMP  R0  R1                        ; if(current == target)
                 BEQ  y_stop                        ; then stop the motor.
                 BLT  y_positive                    ; else if(current < target) then move in positive direction.
                LOAD  R0  -1                        ; else move in negative direction.
                STOR  R0  [GB+MOTORDIRECTION2]      
                 BRA  check_pos_r                   ; return

y_stop:         LOAD  R0  0                         ; Stop the motor.
                STOR  R0  [GB+MOTORDIRECTION2]
                 BRA  check_pos_r
                 
y_positive:     LOAD  R0  1                         ; Move the motor in positive direction.
                STOR  R0  [GB+MOTORDIRECTION2]
                 BRA  check_pos_r

check_pos_r:    PULL  R1
                PULL  R0
                 RTS
@END