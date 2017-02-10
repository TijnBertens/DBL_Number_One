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
;      R0 : upon entry, contains the number
;      R1 : upon exit,  contains the resulting pattern
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
Hex7Seg_bgn:     AND  R0  %01111   ;  R0 := R0 MOD 16 , just to be safe...
                LOAD  R1  [SP++]   ;  R1 := address(tbl) (retrieve from stack)
                LOAD  R1  [R1+R0]  ;  R1 := tbl[R0]
                 RTS
				 
main:		    LOAD  R5  IOAREA    ; R5 will store the start of the IOAREA.
				LOAD  R0  [R5+TIMER]
				STOR  R0  [GB+PREVTIMESTAMP0]

main_loop:       BRS  poll_inputs     
				LOAD  
                
				
                 BRA  main_loop                      ; Loop back to the start of the loop.
				 
drive_motor_0:	LOAD  R0  [GB+PREVTIMESTAMP0]        ;   
				LOAD  R1  [R5+TIMER]                
                LOAD  R3  [GB+OUTPUT]
                 SUB  R0  R1                         ; R0 = prev_timestamp - current_timer
				 CMP  R0  [GB+MOTORSPEED0]           ; if (prev_timestamp - current_timer) > motorspeed
				 BGE  motor0off                      ; then motor off
                LOAD  R2  [GB+MOTORDIRECTION0]       ; else motor on
                 CMP  R2  0   
                 BEQ  motor0left               
                  OR  R3  %001
                STOR  R3  [GB+OUTPUT]
                 RTS            
motor0left:       OR  R3  %010
                STOR  R3  [GB+OUTPUT]
                 RTS
motor0off:       AND  R3  %100
                STOR  R3  [GB+OUTPUT]
                 RTS
				 
poll_inputs:	LOAD  R0  [R5+INPUT]			; get the new button state and update the previous button state
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
				
				RTS
				
				
				