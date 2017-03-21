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
				
;---------------------------------------------------------------------------------;				 				 
; INPUT: RO = x; R1 = y
				
move_to_pos:
				PUSH R0
				PUSH R1
				PUSH R2
				PUSH R3
				
				 CMP R0  [GB+POS_X]			
				 BNE move_while_begin
				 CMP R1  [GB+POS_Y]
				 BEQ move_to_pos_r
    
move_while_begin:
				 BRS essential_routines
				
				STOR R0  [GB+TARGET_X]
				STOR R1  [GB+TARGET_Y]
				
				LOAD R2  [GB+POS_X]
				LOAD R3  [GB+POS_Y]
				
				 CMP R2  R0					;if(x != tarx || y != tarY) => wait
				 BNE move_while_begin
				 CMP R3  R1
				 BNE move_while_begin
				
                 CMP R0  3
                 BNE move_to_pos_r
                 CMP R1  2
                 BNE move_to_pos_r
                 
                 PUSH  R0
                 LOAD  R0  2500
                  BRS  sleep_i
                 PULL  R0
                 
                 BRS poll_inputs
                 BRS handle_scanners
                LOAD R2  [GB+SCANNEDCOLOR]
                 CMP R2  1
                 BEQ move_to_pos_r
                 
                LOAD R0  ' 4'
                 BRA error_state
                
move_to_pos_r:  PULL R3
				PULL R2
				PULL R1
				PULL R0
				 RTS

;---------------------------------------------------------------------------------;				 				 

scan_grid:      PUSH  R0
				PUSH  R1
				PUSH  R2
          
                 BRS  store_prev_grid
          
				LOAD  R0  2
				LOAD  R1  2
				 BRS  move_to_pos
                 ;BRS  place_disk
                 ;BRS sleep
                PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  scan_current_position
                 BRS  color_dsp
                
                 ;BRS  sleep
				 
				LOAD  R0  1
				LOAD  R1  2
				 BRS  move_to_pos
                PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                  
                 ;BRS sleep
				 BRS  scan_current_position
                 BRS  color_dsp
                 ;BRS  sleep
				 
				LOAD  R0  0
				LOAD  R1  2
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                  
                 ;BRS sleep
				 BRS  scan_current_position
                 BRS  color_dsp
                 ;BRS  sleep
				
				LOAD  R0  0
				LOAD  R1  1
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                  
                 ;BRS sleep
				 BRS  scan_current_position
                 BRS  color_dsp
                ; BRS  sleep
				
				LOAD  R0  0
				LOAD  R1  0
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                  
                 ;BRS sleep
				 BRS  scan_current_position
                 BRS  color_dsp
                 ;BRS  sleep
				
				LOAD  R0  1
				LOAD  R1  0
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                  
                 ;BRS sleep
				 BRS  scan_current_position
                 BRS  color_dsp
                 ;BRS  sleep
				
				LOAD  R0  2
				LOAD  R1  0
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                  
                 ;BRS sleep
				 BRS  scan_current_position
                 BRS  color_dsp
                 ;BRS  sleep
				
				LOAD  R0  2
				LOAD  R1  1
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                  
                 ;BRS sleep
				 BRS  scan_current_position
                 BRS  color_dsp
                 ;BRS  sleep
				
				LOAD  R0  1
				LOAD  R1  1
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                  
                 ;BRS sleep
				 BRS  scan_current_position
                 BRS  color_dsp
				 ;BRS  sleep
				
                 BRS  check_cheating
                
                PULL  R2
				PULL  R1
				PULL  R0
				 RTS
                 
color_dsp:      LOAD  R2 GB
                 ADD  R2 GRID
                 ADD  R2 R0
                 MULS R1 3
                 ADD  R2 R1
                LOAD  R2 [R2]
                STOR  R2 [GB+DSP_DEC]
                 RTS
@END


