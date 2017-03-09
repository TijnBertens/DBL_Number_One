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
  SCANNEDCOLOR		DW  0		  ;  0 - white, 1 - background, 2 - red
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
  
  ; Virtual playing field (x + 3y)
  GRID				DS  10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

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
@INCLUDE "game.asm"
  
@CODE
begin :          BRA  main         ;  skip subroutine Hex7Seg


;  
;     
				 
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
                
main_loop:       BRS  essential_routines
                
                 BRA  main_loop                      ; Loop back to the start of the loop.
				 
;---------------------------------------------------------------------------------;	

essential_routines:
				BRS  poll_inputs     
				BRS  handle_btns
				BRS  handle_scanners
				BRS  display_decimal_number
				BRS  check_pos
    			BRS  drive_motors1
				RTS

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