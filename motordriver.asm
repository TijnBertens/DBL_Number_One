@CODE
BRA main
   
drive_motors1:	PUSH  R0
				PUSH  R1
				PUSH  R2
				PUSH  R3
				
				LOAD  R0  [R5+TIMER]			;  R0 := current time

m0:				LOAD  R1  [GB+MOTORPREVTIME]		;  R1 := prev time
				LOAD  R2  R0					;  R2 := current time
				 SUB  R2  R1					;  R2 := current - prev
				 CMP  R2  [GB+MOTORSPEED0]      ;  if(R2 > motorspeed)
				 BLE  m1	;dont turn off
				
				LOAD  R3  [GB+OUTPUTSTATE]			;  turn off motor 0
				 AND  R3  %111111110
				STOR  R3  [GB+OUTPUTSTATE]
				
m1:				LOAD  R1  [GB+MOTORPREVTIME]		;  R1 := prev time
				LOAD  R2  R0					;  R2 := current time
				 SUB  R2  R1					;  R2 := current - prev
				 CMP  R2  [GB+MOTORSPEED1]      ;  if(R2 > motorspeed)
				 BLE  m2	;dont turn off
				
				LOAD  R3  [GB+OUTPUTSTATE]			;  turn off motor 0
				 AND  R3  %111111011
				STOR  R3  [GB+OUTPUTSTATE]		
				
m2:				LOAD  R1  [GB+MOTORPREVTIME]		;  R1 := prev time
				LOAD  R2  R0					;  R2 := current time
				 SUB  R2  R1					;  R2 := current - prev
				 CMP  R2  [GB+MOTORSPEED2]      ;  if(R2 > motorspeed)
				 BLE  on	;dont turn off
				
				LOAD  R3  [GB+OUTPUTSTATE]			;  turn off motor 0
				 AND  R3  %111101111
				STOR  R3  [GB+OUTPUTSTATE]		
				
on:				 CMP  R2  100
				 BLE  r_drive_motors1
				LOAD  R3  [GB+OUTPUTSTATE]
				  OR  R3  %000010101
				STOR  R0  [GB+MOTORPREVTIME]
				
r_drive_motors1: LOAD  R0  [GB+OUTPUTSTATE]
				STOR  R0  [R5+OUTPUT]
				
				PULL  R3
				PULL  R2
				PULL  R1
				PULL  R0 
				 RTS				
				 
   
   
drive_motors:	PUSH  R0
				PUSH  R1
				PUSH  R2
				PUSH  R3

				LOAD  R0  [GB+NEXTTIME0]             ; R0 = next time to turn motor on
                LOAD  R1  [R5+TIMER]                 ; R1 = current timer          
                LOAD  R3  [R5+OUTPUT]                ; R3 = current output
                 SUB  R1  R0                         ; 
                MULS  R1  -1                         ; R1 = next_time - current_time
                
				 CMP  R1  [GB+MOTORSPEED0]           ; if (next_time - current_time) > motorspeed
				 BGE  motorsoff                      ; then motor off
                 
                LOAD  R2  [GB+MOTORDIRECTION0]       ; else motor on
                 CMP  R2  0
                 BEQ  motor1
                 CMP  R2  -1   						 ; check if the motor direction is 0 (left)
                 BEQ  motor0lleft               		 ; if (motordirection == 0) go to motor0left
                 AND  R3  %111100						 ; turn the motor off
                  OR  R3  %000001						 ; turn on the motor to the right
                STOR  R3  [R5+OUTPUT]		
                 BRA  motor1
motor0lleft:     AND  R3  %111100						 ; turn the motor off
				  OR  R3  %000010						 ; turn on the motor to the left
                STOR  R3  [R5+OUTPUT]
				
motor1:			LOAD  R2  [GB+MOTORDIRECTION1]       ; else motor on
                 CMP  R2  0   						 ; check if the motor direction is 0 (off)
                 BEQ  motor2                             ; if (motordirection == 0) go to motor1
                 CMP  R1  -1
                 BEQ  motor1lleft               		 ; if (motordirection == 0) go to motor0left
                 AND  R3  %110011						 ; turn the motor off
                  OR  R3  %000100						 ; turn on the motor to the right
                STOR  R3  [R5+OUTPUT]		
                 BRA  motor2
motor1lleft:     AND  R3  %110011						 ; turn the motor off
				  OR  R3  %001000						 ; turn on the motor to the left
                STOR  R3  [R5+OUTPUT]
				
motor2:			LOAD  R2  [GB+MOTORDIRECTION2]       ; else motor on
                 CMP  R2  0   						 ; check if the motor direction is 0 (off)
                 BEQ  update_ts
                 BEQ  motor2lleft               		 ; if (motordirection == 0) go to motor0left
                 AND  R3  %1001111						 ; turn the motor off
                  OR  R3  %0010000						 ; turn on the motor to the right
                STOR  R3  [R5+OUTPUT]		
                 BRA  update_ts
motor2lleft:     AND  R3  %1001111						 ; turn the motor off
				  OR  R3  %0100000						 ; turn on the motor to the left
                STOR  R3  [R5+OUTPUT]
				
                 BRA  update_ts
motorsoff:       AND  R3  %1000000						 ; turn the motor off
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts
				 
update_ts:		 CMP  R1  100						 ; if (next_time - current_time) < 
				 BLE  r_drive_motor                ; then return
				LOAD  R0  [R5+TIMER]                 ; else set the next time to turn motor on
                 SUB  R1  100
                 SUB  R0  R1
				STOR  R0  [GB+NEXTTIME0]
				
r_drive_motor:
				PULL  R3
				PULL  R2
				PULL  R1
				PULL  R0
				
				RTS								 ; return

	
drive_motor_0:	PUSH  R0
				PUSH  R1
				PUSH  R2
				PUSH  R3

				LOAD  R0  [GB+NEXTTIME0]             ; R0 = next time to turn motor on
                LOAD  R1  [R5+TIMER]                 ; R1 = current timer          
                LOAD  R3  [R5+OUTPUT]                ; R3 = current output
                 SUB  R1  R0                         ; 
                MULS  R1  -1                         ; R1 = next_time - current_time
                
				 CMP  R1  [GB+MOTORSPEED0]           ; if (next_time - current_time) > motorspeed
				 BGE  motor0off                      ; then motor off
                LOAD  R2  [GB+MOTORDIRECTION0]       ; else motor on
                 CMP  R2  0   						 ; check if the motor direction is 0 (left)
                 BEQ  motor0left               		 ; if (motordirection == 0) go to motor0left
                 AND  R3  %111100						 ; turn the motor off
                  OR  R3  %001						 ; turn on the motor to the right
                STOR  R3  [R5+OUTPUT]		
                 BRA  update_ts0
motor0left:      AND  R3  %111100						 ; turn the motor off
				  OR  R3  %010						 ; turn on the motor to the left
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts0
motor0off:       AND  R3  %111100						 ; turn the motor off
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts0
				 
update_ts0:		 CMP  R1  100						 ; if (next_time - current_time) < 
				 BLE  r_drive_motor_0                ; then return
				LOAD  R0  [R5+TIMER]                 ; else set the next time to turn motor on
                 SUB  R1  100
                 SUB  R0  R1
				STOR  R0  [GB+NEXTTIME0]
				
r_drive_motor_0:
				PULL  R3
				PULL  R2
				PULL  R1
				PULL  R0
				
				RTS								 ; return

;---------------------------------------------------------------------------------;
				 				 
drive_motor_1:	PUSH  R0
				PUSH  R1
				PUSH  R2
				PUSH  R3

				LOAD  R0  [GB+NEXTTIME1]             ; R0 = next time to turn motor on
                LOAD  R1  [R5+TIMER]                 ; R1 = current timer          
                LOAD  R3  [R5+OUTPUT]                ; R3 = current output
                 SUB  R1  R0                         ; 
                MULS  R1  -1                         ; R1 = next_time - current_time
                
				 CMP  R1  [GB+MOTORSPEED1]           ; if (next_time - current_time) > motorspeed
				 BGE  motor1off                      ; then motor off
                LOAD  R2  [GB+MOTORDIRECTION1]       ; else motor on
                 CMP  R2  0   						 ; check if the motor direction is 0 (left)
                 BEQ  motor1left               		 ; if (motordirection == 0) go to motor0left
                 AND  R3  %10011					 ; turn the motor off
                  OR  R3  %00100					 ; turn on the motor to the right
                STOR  R3  [R5+OUTPUT]		
                 BRA  update_ts1
motor1left:      AND  R3  %10011					 ; turn the motor off
				  OR  R3  %01000					 ; turn on the motor to the left
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts1
motor1off:       AND  R3  %10011					 ; turn the motor off
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts1
				 
update_ts1:		 CMP  R1  100						 ; if (next_time - current_time) < 
				 BLE  r_drive_motor_1                ; then return
				LOAD  R0  [R5+TIMER]                 ; else set the next time to turn motor on
                 SUB  R1  100
                 SUB  R0  R1
				STOR  R0  [GB+NEXTTIME1]
				
r_drive_motor_1:
				PULL  R3
				PULL  R2
				PULL  R1
				PULL  R0
				
				RTS								 ; return

;---------------------------------------------------------------------------------;
				 
drive_motor_2:	PUSH  R0
				PUSH  R1
				PUSH  R2
				PUSH  R3

				LOAD  R0  [GB+NEXTTIME2]             ; R0 = next time to turn motor on
                LOAD  R1  [R5+TIMER]                 ; R1 = current timer          
                LOAD  R3  [R5+OUTPUT]                ; R3 = current output
                 SUB  R1  R0                         ; 
                MULS  R1  -1                         ; R1 = next_time - current_time
                
				 CMP  R1  [GB+MOTORSPEED2]           ; if (next_time - current_time) > motorspeed
				 BGE  motor2off                      ; then motor off
                LOAD  R2  [GB+MOTORDIRECTION2]       ; else motor on
                 CMP  R2  0   						 ; check if the motor direction is 0 (left)
                 BEQ  motor2left               		 ; if (motordirection == 0) go to motor0left
                 AND  R3  %1001111					 ; turn the motor off
                  OR  R3  %0010000					 ; turn on the motor to the right
                STOR  R3  [R5+OUTPUT]		
                 BRA  update_ts2
motor2left:      AND  R3  %1001111					 ; turn the motor off
				  OR  R3  %0100000					 ; turn on the motor to the left
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts2
motor2off:       AND  R3  %1001111					 ; turn the motor off
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts2
				 
update_ts2:		 CMP  R1  100						 ; if (next_time - current_time) < 
				 BLE  r_drive_motor_2                ; then return
				LOAD  R0  [R5+TIMER]                 ; else set the next time to turn motor on
                 SUB  R1  100
                 SUB  R0  R1
				STOR  R0  [GB+NEXTTIME2]
				
r_drive_motor_2:
				PULL  R3
				PULL  R2
				PULL  R1
				PULL  R0
				
				RTS								 ; return
@END                