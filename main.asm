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
  SCANNEDCOLOR		DW  0		  ;  0 - white, 1 - background, 2 - black
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
  MOTORSPEED1 		DW  75
  MOTORDIRECTION1   DW  0
  ; MOTOR 2 - Y-AXIS
  NEXTTIME2         DW  0
  PREVTIME2			DW  0
  MOTORSPEED2 		DW  45
  MOTORDIRECTION2   DW  0
  
  ; POSITION
  POS_X             DW  3
  POS_Y             DW  2
  TARGET_X          DW  3
  TARGET_Y          DW  2
  
  ; Virtual playing field (x + 3y)
  GRID				DS  10;, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 
  ; BOARD STATE:  00 = wildcard, 01 = background, 10 = unwanted, 11 = wanted
  ; Fork diagnal 0
  FORK_DIAG0        DW  %000011000001110101, 8, 7, %110101000001000011, 2, 1, %010111010000110000, 0, 1, %110000010000010111, 6, 3
  FORK_COR_ADJ	    DW 	%000001110101110000, 4, 4, %010100000100001111, 4, 4, %000011010111010000, 4, 4, %111100000100000101, 4, 4, %110000110101000001, 4, 4, %000101000100111100, 4, 4, %000000010111010011, 4, 4, %001111000100010100, 4, 4
  FORK_CTR_ADJ	    DW 	%010000111100010001, 0, 0, %010001111100010000, 6, 6, %000001001100011101, 6, 6, %010000001100011101, 8, 8, %010001001111000001, 8, 8, %000001001111010001, 2, 2, %011101001100010000, 2, 2, %011101001100000001, 0, 0
  FORK_CTR_COR	    DW	%010000001100110101, 8, 8, %010000011100110001, 0, 0, %000001001101010011, 2, 2, %000001001100010111, 6, 6, %010011001101000001, 8, 8, %010111001100000001, 0, 0, %110101001100010000, 2, 2, %110001011100010000, 6, 6, %110101001100000100, 1, 2, %110000011101010000, 3, 6, %010111001100000100, 1, 0, %000011011101000001, 5, 8, %000100001100110101, 7, 8, %010000011101110000, 3, 0, %000100001100010111, 7, 6 
  FORK_ADJ_COR	    DW	%010000010100110011, 0, 4, %000001000101110011, 2, 4, %010001000100110011, 4, 4, %110000000100110101, 8, 4, %110101000100110000, 2, 4, %110001000100110001, 4, 4, %110011000100010001, 4, 4, %110011010100010000, 6, 4, %010011000100010011, 4, 4, %010111000100000011, 0, 4, %110011000101000001, 8, 4, %000011000100010111, 6, 4
  FORK_EDG_OP_COR	DW 	%010000110101000011, 4, 4, %010000110100010011, 0, 4, %000111000100011100, 4, 4, %010000110000010111, 6, 6, %000011000001011101, 8, 8, %011101000100110000, 2, 4, %110101000011000001, 2, 2, %110000010111000001, 4, 4, %011101010000110000, 0, 0, %001101000100110100, 4, 4, %110000000100011101, 8, 4, %110100000100001101, 4, 4, %110000010000011101, 6, 6, %000001000011110101, 8, 8, %010011110100010000, 6, 4, %000011110101010000, 4, 4, %010111110000010000, 0, 0, %000001010111110000, 4, 4, %000001000111110001, 2, 4, %011101000100000011, 0, 4, %011100000100000111, 4, 4, %011101000001000011, 2, 2, %110101000100001100, 1, 1, %001100000100010111, 7, 7, %010000010111110000, 3, 3, %110000010111010000, 3, 3, %010111000100001100, 1, 1, %001100000100110101, 7, 7, %000001110101000011, 5, 5 
  FORK_EDG_PER	    DW 	%010000110000011101, 6, 6, %000001000011011101, 8, 8, %011101000011000001, 2, 2, %011101110000010000, 0, 0, %000100110101001100, 4, 4, %000100010111001100, 4, 4, %001100110101000100, 4, 4, %001100010111000100, 4, 4 
  FORK_TERMINATOR   DW  -1
  
  ; DISPLAY
  DSP_DEC           DW  -1                  ; The decimal value to display, set negative to display ascii instead (next lines).
  DSP_ASCII         DW  '  '                ; The ascii value to display in 3 words, 2 characters each.
  DSP_ASCII_1       DW  '  '
  DSP_ASCII_2       DW  '  '

  ;FAILURE VARIABLES
  
  BTN_5_TS          DW  0
  BTN_6_TS          DW  0
  BTN_7_TS          DW  0
  
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
@INCLUDE "failuredetection.asm"
  
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
                LOAD  R0  %010000000
                STOR  R0  [GB+OUTPUTSTATE]
                LOAD  R0  0
                
main_loop:       BRS  essential_routines
                 ;BRS  scan_grid
                 ;ADD  R0  1
                ;LOAD  R2  R0
                ;MULS  R2  10000
                ;LOAD  R1  [GB+DSP_DEC]
                 ;;ADD  R1  R2
                ;STOR  R1  [GB+DSP_DEC]
                 BRA  main_loop                      ; Loop back to the start of the loop.
				 
;---------------------------------------------------------------------------------;	

essential_routines:
				BRS  poll_inputs     
				BRS  handle_btns
				BRS  check_engine_failure
				BRS  handle_scanners
				BRS  update_display
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
             
             LOAD  R0  %10000000
             STOR  R0  [R5+OUTPUT]
             STOR  R0  [GB+OUTPUTSTATE]
			 LOAD  R0  [R5+TIMER]
d_w:		 LOAD  R1  [R5+TIMER]
             BRS  update_display			 
             SUB  R1  R0
			  CMP  R1  -10000
			  BGE  d_w
			 PULL  R1				; restore registers
			 PULL  R0
			  RTS			
;---------------------------------------------------------------------------------;					
;INPUT: R0 time, positive value
sleep_i:	 PUSH  R0
             PUSH  R1				; save registers
			 PUSH  R2
             
             MULS  R0  -1
             LOAD  R1  %10000000
             STOR  R1  [R5+OUTPUT]
             STOR  R1  [GB+OUTPUTSTATE]
			 LOAD  R1  [R5+TIMER]
d_w_i:		 LOAD  R2  [R5+TIMER]
              BRS  update_display			 
              SUB  R2  R1
			  CMP  R2  R0
			  BGE  d_w_i

             PULL  R2				; restore registers
			 PULL  R1
             PULL  R0
			  RTS			              
@END              