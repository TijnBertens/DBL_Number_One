@CODE
BRA begin
   
drive_motors1:	PUSH  R0
				PUSH  R1
				PUSH  R2
				PUSH  R3
				
				LOAD  R0  [R5+TIMER]			;  R0 := current time
				LOAD  R1  [GB+MOTORPREVTIME]	;  R1 := prev time
				LOAD  R2  R1					;  R2 := prev time
				 SUB  R2  R0					;  R2 := prev - new

m0:				 CMP  R2  [GB+MOTORSPEED0]      ;  if(R2 > motorspeed)
				 BLE  m1						;dont turn off
				
				LOAD  R3  [GB+OUTPUTSTATE]		;  turn off motor 0
				 AND  R3  %111111100
				STOR  R3  [GB+OUTPUTSTATE]
				
m1:				 CMP  R2  [GB+MOTORSPEED1]      ;  if(R2 > motorspeed)
				 BLE  m2	;dont turn off
				
				LOAD  R3  [GB+OUTPUTSTATE]		;  turn off motor 1
				 AND  R3  %111110011
				STOR  R3  [GB+OUTPUTSTATE]		
				
m2:				 CMP  R2  [GB+MOTORSPEED2]      ;  if(R2 > motorspeed)
				 BLE  on	;dont turn off
				
				LOAD  R3  [GB+OUTPUTSTATE]		;  turn off motor 2
				 AND  R3  %111001111
				STOR  R3  [GB+OUTPUTSTATE]		
				
on:				 CMP  R2  100
				 BLE  r_drive_motors1
				LOAD  R3  [GB+OUTPUTSTATE]
				
				LOAD  R4  [GB+MOTORDIRECTION0]	; R4 := motordirection
				 CMP  R4  0						; check the motor direction {-1,0,1}
				 BEQ  m1_right					; 0 => off
				 BLT  m0_left					; -1 => left
				  OR  R3  %000000001			;  1 => right
				 BRA  m1_right
m0_left:		  OR  R3  %000000010
				  
m1_right:		LOAD  R4  [GB+MOTORDIRECTION1]	; R4 := motordirection
				 CMP  R4  0						; check the motor direction {-1,0,1}
				 BEQ  m2_right					; 0 => off
				 BLT  m1_left					; -1 => left
				  OR  R3  %000000100			;  1 => right
				 BRA  m2_right
m1_left:		  OR  R3  %000001000

m2_right:		LOAD  R4  [GB+MOTORDIRECTION2]	; R4 := motordirection
				 CMP  R4  0						; check the motor direction {-1,0,1}
				 BEQ  m_end						; 0 => off
				 BLT  m2_left 					; -1 => left
				  OR  R3  %000010000			;  1 => right
				 BRA  m_end
m2_left:		  OR  R3  %000100000
				  
				  
m_end:			STOR  R3  [GB+OUTPUTSTATE]
				STOR  R0  [GB+MOTORPREVTIME]
				
r_drive_motors1: LOAD  R0  [GB+OUTPUTSTATE]
				STOR  R0  [R5+OUTPUT]
				
				PULL  R3
				PULL  R2
				PULL  R1
				PULL  R0 
				 RTS

;---------------------------------------------------------------------------------;	

place_disk:     PUSH  R0
                LOAD  R0  [R5+TIMER]
                STOR  R0  [GB+BTN_5_TS]
place_disk_while:				
                LOAD  R0  1						; set the motordirection to 1
				STOR  R0  [GB+MOTORDIRECTION1]	; on the disc placer motor (motor 1)			 
                 BRS  essential_routines
                LOAD  R0  [GB+MOTORDIRECTION1]
                 BNE  place_disk_while
                 BRS  sleep
                
				PULL  R0
				RTS
@END                