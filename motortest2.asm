@DATA
  ANALOG0			DW  0
  ANALOG1			DW  0
  INPUTSTATE		DW  0
  PREVINPUTSTATE    DW  0
  NXT_DSP           DW  0       ; The next display to update, modulo 100
  
  ; MOTOR 1
  NEXTTIME0         DW  0
  MOTORSPEED0 		DW  0
  MOTORDIRECTION0   DW  0
  ; MOTOR 2
  NEXTTIME1         DW  0
  MOTORSPEED1 		DW  0
  MOTORDIRECTION1   DW  0
  ; MOTOR 3
  NEXTTIME2         DW  0
  MOTORSPEED2 		DW  0
  MOTORDIRECTION2   DW  0
@CODE

   IOAREA      EQU  -16  ;  address of the I/O-Area, modulo 2^18
    INPUT      EQU    7  ;  position of the input buttons (relative to IOAREA)
   OUTPUT      EQU   11  ;  relative position of the power outputs
   DSPDIG      EQU    9  ;  relative position of the 7-segment display's digit selector
   DSPSEG      EQU    8  ;  relative position of the 7-segment display's segments
   TIMER       EQU   13
   ADCONVS     EQU    6  ;  relative position of the A/D converters.

begin :          BRA  main         ;  skip subroutine Hex7Seg
;  
;      Routine Hex7Seg maps a number in the range [0..15] to its hexadecimal
;      representation pattern for the 7-segment display.
;      R1 : upon entry, contains the number
;      R2 : upon exit,  contains the resulting pattern
;
Hex7Seg     :    BRS  Hex7Seg_bgn  ;  push address(tbl) onto stack and proceed at "bgn"
Hex7Seg_tbl :   CONS  %01111110    ;  7-segment pattern for '0'
                CONS  %00110000    ;  7-segment pattern for '1'
                CONS  %01101101    ;  7-segment pattern for '2'
                CONS  %01111001    ;  7-segment pattern for '3'
                CONS  %00110011    ;  7-segment pattern for '4'
                CONS  %01011011    ;  7-segment pattern for '5'
                CONS  %01011111    ;  7-segment pattern for '6'
                CONS  %01110000    ;  7-segment pattern for '7'
                CONS  %01111111    ;  7-segment pattern for '8'
                CONS  %01111011    ;  7-segment pattern for '9'
                CONS  %01110111    ;  7-segment pattern for 'A'
                CONS  %00011111    ;  7-segment pattern for 'b'
                CONS  %01001110    ;  7-segment pattern for 'C'
                CONS  %00111101    ;  7-segment pattern for 'd'
                CONS  %01001111    ;  7-segment pattern for 'E'
                CONS  %01000111    ;  7-segment pattern for 'F'
Hex7Seg_bgn:     AND  R1  %01111   ;  R0 := R0 MOD 16 , just to be safe...
                LOAD  R2  [SP++]   ;  R1 := address(tbl) (retrieve from stack)
                LOAD  R2  [R2+R1]  ;  R1 := tbl[R0]
                 RTS
				 
;---------------------------------------------------------------------------------;				 				 
				 
main:		    LOAD  R5  IOAREA                ; R5 will store the start of the IOAREA.
				LOAD  R0  [R5+TIMER]            ; Store the current timer in NEXTTIMEs
                STOR  R0  [GB+NEXTTIME0]
                STOR  R0  [GB+NEXTTIME1]
                STOR  R0  [GB+NEXTTIME2]

main_loop:       BRS  poll_inputs     
				LOAD  R0  [GB+ANALOG0]
				MULS  R0  100
				 DIV  R0  255
                STOR  R0  [GB+MOTORSPEED0]
                STOR  R0  [GB+MOTORSPEED1]
                STOR  R0  [GB+MOTORSPEED2]
                 BRS  display_decimal_number
                ; BRS  drive_motor_0		
                 
                 ;LOAD  R0  [R5+TIMER]
				 BRS  drive_motor_2		
				 BRS  drive_motor_1		
				  ;BRS  sleep
				  ;SUB  R0  [R5+TIMER]
				  ;BRS  display_decimal_number
				 
                 BRA  main_loop                      ; Loop back to the start of the loop.
				 
;---------------------------------------------------------------------------------;				 
				 
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

;---------------------------------------------------------------------------------;
poll_inputs:	PUSH  R0
				PUSH  R1
				
				LOAD  R0  [R5+INPUT]			; get the new button state and update the previous button state
				LOAD  R1  [GB+INPUTSTATE]
				STOR  R0  [GB+INPUTSTATE]
				STOR  R1  [GB+PREVINPUTSTATE]
				
				LOAD  R0  [R5+ADCONVS]			; get the value on adconvs port 0
				 AND  R0  %011111111	
				STOR  R0  [GB+ANALOG0]
				
				LOAD  R0  [R5+ADCONVS]			; get the value on adconvs port 1
				 DIV  R0  %010000000
				 AND  R0  %011111111
				STOR  R0  [GB+ANALOG1]
				
				PULL  R1
				PULL  R0
				RTS
				
;---------------------------------------------------------------------------------;				

display_decimal_number:
			 PUSH  R1
			 PUSH  R2
             PUSH  R3
             
             LOAD  R3 [GB+NXT_DSP]
              ADD  R3 1
             STOR  R3 [GB+NXT_DSP]
              DIV  R3 100
              CMP  R3 0
              BEQ  dsp_0
              CMP  R3 1
              BEQ  dsp_1
              CMP  R3 2
              BEQ  dsp_2
              CMP  R3 3
              BEQ  dsp_3
              CMP  R3 4
              BEQ  dsp_4
              CMP  R3 5
              BEQ  dsp_5
             LOAD  R3 0
             STOR  R3 [GB+NXT_DSP]
              BRA  r_display
             
dsp_0:		 LOAD  R1  R0				; load a copy of n into R0
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the displa code
			 LOAD  R1  %01				; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			 
dsp_1:	     LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  10				; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %010				; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			  
dsp_2:       LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  100				; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %0100			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			 
dsp_3:		 LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  1000
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the displa code
			 LOAD  R1  %01000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			 
dsp_4:		 LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  10000			; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %010000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			  
dsp_5:		 LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  100000			; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %0100000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			 
r_display:   PULL  R3
			 PULL  R2
			 PULL  R1
			 
			  RTS

;---------------------------------------------------------------------------------;	
				
sleep:		 PUSH  R0				; save registers
			 PUSH  R1
			 LOAD  R0  [R5+TIMER]
d_w:		 LOAD  R1  [R5+TIMER]
			  SUB  R1  R0
			  CMP  R1  -10
			  BGE  d_w
			 PULL  R1				; restore registers
			 PULL  R0
			  RTS				