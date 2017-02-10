@DATA
  ANALOG0			DW  0
  ANALOG1			DW  0
  INPUTSTATE		DW  0
  PREVINPUTSTATE    DW  0
  
  ; MOTOR 1
  PREVTIMESTAMP0    DW  0
  MOTORSPEED0 		DW  0
  MOTORDIRECTION0   DW  0
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
				 
main:		    LOAD  R5  IOAREA    ; R5 will store the start of the IOAREA.
				LOAD  R0  [R5+TIMER]
				STOR  R0  [GB+PREVTIMESTAMP0]

main_loop:       BRS  poll_inputs     
				LOAD  R0  [GB+ANALOG0]
				MULS  R0  100
				 DIV  R0  255
			     BRS  display_decimal_number
				STOR  R0  [GB+MOTORSPEED0]
                 BRS  drive_motor_0				
                 BRA  main_loop                      ; Loop back to the start of the loop.
				 
;---------------------------------------------------------------------------------;				 
				 
drive_motor_0:	PUSH  R0
				PUSH  R1
				PUSH  R2
				PUSH  R3

				LOAD  R0  [GB+PREVTIMESTAMP0]        ;   
				LOAD  R1  [R5+TIMER]                
                LOAD  R3  [GB+OUTPUT]
                 SUB  R0  R1                         ; R0 = prev_timestamp - current_timer
				 CMP  R0  [GB+MOTORSPEED0]           ; if (prev_timestamp - current_timer) > motorspeed
				 BGE  motor0off                      ; then motor off
                LOAD  R2  [GB+MOTORDIRECTION0]       ; else motor on
                 CMP  R2  0   						 ; check if the motor direction is 0 (left)
                 BEQ  motor0left               		 ; if (motordirection == 0) go to motor0left
				 AND  R3  %100						 ; turn the motor off
                  OR  R3  %001						 ; turn on the motor to the right
                STOR  R3  [R5+OUTPUT]		
                 BRA  update_ts0
motor0left:      AND  R3  %100						 ; turn the motor off
				  OR  R3  %010						 ; turn on the motor to the left
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts0
motor0off:       AND  R3  %100						 ; turn the motor off
                STOR  R3  [R5+OUTPUT]
                 BRA  update_ts0
				 
update_ts0:		 CMP  R0  100						 ; if 100 clock ticks have passed, turn the motor off
				 BLE  r_drive_motor_0
				LOAD  R1  [R5+TIMER]
				STOR  R1  [GB+PREVTIMESTAMP0]
				
r_drive_motor_0:
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

			 LOAD  R1  R0				; load a copy of n into R0
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the displa code
			 LOAD  R1  %01				; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRS  sleep
			 
			 LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  10				; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %010				; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRS  sleep
			  
			 LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  100				; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %0100			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRS  sleep
			 
			 LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  1000
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the displa code
			 LOAD  R1  %01000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRS  sleep
			 
			 LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  10000			; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %010000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRS  sleep
			  
			 LOAD  R1  R0				; load a copy of n into R0
			  DIV  R1  100000			; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
			 STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %0100000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRS  sleep
			 
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