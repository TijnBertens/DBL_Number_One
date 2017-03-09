@DATA

  ; INPUTS ;
  PREVANALOG0		DW  0
  ANALOG0			DW  0
  
  PREVANALOG1		DW  0
  ANALOG1			DW  0
  
  INPUTSTATE		DW  0
  PREVINPUTSTATE    DW  0
  
  ; MISC ;
  NXT_DSP           DW  100       ; The next display to update, modulo 100
  OUTPUTSTATE		DW  0
  
  ; COLOR SCANNER
  SCANNEDCOLOR		DW  0		  ;  0 - white, 1 - background, 2 - blue
  PREVSCANNEDCOLOR	DW  0
  
  MOTORPREVTIME		DW  0
  ; MOTOR 0 - X-AXIS
  NEXTTIME0         DW  0
  PREVTIME0			DW  0
  MOTORSPEED0 		DW  80
  MOTORDIRECTION0   DW  0
  ; MOTOR 1 - EXTRUDOR
  NEXTTIME1         DW  0
  PREVTIME1			DW  0
  MOTORSPEED1 		DW  80
  MOTORDIRECTION1   DW  0
  ; MOTOR 2 - Y-AXIS
  NEXTTIME2         DW  0
  PREVTIME2			DW  0
  MOTORSPEED2 		DW  45
  MOTORDIRECTION2   DW  0
  
  ; POSITION
  POS_X             DW  0
  POS_Y             DW  0
  TARGET_X          DW  0
  TARGET_Y          DW  0

   IOAREA      EQU  -16  ;  address of the I/O-Area, modulo 2^18
    INPUT      EQU    7  ;  position of the input buttons (relative to IOAREA)
   OUTPUT      EQU   11  ;  relative position of the power outputs
   DSPDIG      EQU    9  ;  relative position of the 7-segment display's digit selector
   DSPSEG      EQU    8  ;  relative position of the 7-segment display's segments
   TIMER       EQU   13
   ADCONVS     EQU    6  ;  relative position of the A/D converters.  
   
@INCLUDE "motordriver.asm"
@INCLUDE "buttonhandler.asm"
@INCLUDE "displaydriver.asm"
@INCLUDE "scannerhandler.asm"
@INCLUDE "positionhandler.asm"
  
@CODE
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
				 
Alfa7Seg     :  BRS  Alfa7Seg_bgn  ;  push address(tbl) onto stack and proceed at "bgn"
Alfa7Seg_tbl : CONS  %01110111    ;  7-segment pattern for 'a'
              CONS  %00011111    ;  7-segment pattern for 'b'
              CONS  %01001110    ;  7-segment pattern for 'c'
              CONS  %00111101    ;  7-segment pattern for 'd'
              CONS  %01001111    ;  7-segment pattern for 'e'
              CONS  %01000111    ;  7-segment pattern for 'f'
              CONS  %01111011    ;  7-segment pattern for 'g'
              CONS  %00010111    ;  7-segment pattern for 'h'
              CONS  %00110000    ;  7-segment pattern for 'i'
              CONS  %00111000    ;  7-segment pattern for 'j'
              CONS  %01010111    ;  7-segment pattern for 'k'
              CONS  %00001110    ;  7-segment pattern for 'l'
              CONS  %01010100    ;  7-segment pattern for 'm'
              CONS  %00010101    ;  7-segment pattern for 'n'
              CONS  %01111110    ;  7-segment pattern for 'o'
              CONS  %01100111    ;  7-segment pattern for 'p'
			  CONS  %01110011    ;  7-segment pattern for 'q'
              CONS  %01000110    ;  7-segment pattern for 'r'
              CONS  %01011011    ;  7-segment pattern for 's'
              CONS  %00001111    ;  7-segment pattern for 't'
              CONS  %00111110    ;  7-segment pattern for 'u'
              CONS  %00001110    ;  7-segment pattern for 'v'
			  CONS  %00101010    ;  7-segment pattern for 'w'
              CONS  %00110111    ;  7-segment pattern for 'x'
              CONS  %00111011    ;  7-segment pattern for 'y'
              CONS  %01101101    ;  7-segment pattern for 'z'
Alfa7Seg_bgn:  SUB  R0  97
			   MOD  R0  26   	 ;  R0 := R0 MOD 26 , just to be safe...
              LOAD  R1  [SP++]   ;  R1 := address(tbl) (retrieve from stack)
              LOAD  R1  [R1+R0]  ;  R1 := tbl[R0]
               RTS
				 
;---------------------------------------------------------------------------------;				 				 
				 
main:		    LOAD  R5  IOAREA                ; R5 will store the start of the IOAREA.
				LOAD  R0  [R5+TIMER]            ; Store the current timer in NEXTTIMEs
                STOR  R0  [GB+NEXTTIME0]
                STOR  R0  [GB+NEXTTIME1]
                STOR  R0  [GB+NEXTTIME2]
				STOR  R0  [GB+MOTORPREVTIME]
                LOAD  R0  0
                STOR  R0  [GB+MOTORDIRECTION0]
                STOR  R0  [GB+MOTORDIRECTION1]
                STOR  R0  [GB+MOTORDIRECTION2]
                
main_loop:       BRS  poll_inputs     
				 BRS  handle_btns
				 BRS  handle_scanners
				;LOAD  R0  [GB+ANALOG0]
				;MULS  R0  100
				; DIV  R0  255
                 BRS  display_decimal_number
                ;STOR  R0  [GB+MOTORSPEED0]
                ;STOR  R0  [GB+MOTORSPEED2]
                
                 BRS  check_pos
    			 BRS  drive_motors1
                
                 BRA  main_loop                      ; Loop back to the start of the loop.
				 
;---------------------------------------------------------------------------------;	
poll_inputs:	PUSH  R0
				PUSH  R1
				
				LOAD  R0  [R5+INPUT]			; get the new button state and update the previous button state
				LOAD  R1  [GB+INPUTSTATE]
				STOR  R0  [GB+INPUTSTATE]
				STOR  R1  [GB+PREVINPUTSTATE]
				
				LOAD  R0  [R5+ADCONVS]			; get the value on adconvs port 0
				LOAD  R1  [GB+ANALOG0] 
				 AND  R0  %011111111	
				STOR  R0  [GB+ANALOG0]
				STOR  R1  [GB+PREVANALOG0]
				
				LOAD  R0  [R5+ADCONVS]			; get the value on adconvs port 1
				LOAD  R1  [GB+ANALOG1] 
				 DIV  R0  %010000000
				 AND  R0  %011111111
				STOR  R0  [GB+ANALOG1]
				STOR  R1  [GB+PREVANALOG1]
				
				PULL  R1
				PULL  R0
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
@END              