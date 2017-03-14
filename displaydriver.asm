@CODE
; Routine Hex7Seg maps a number in the range [0..15] to its hexadecimal
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
Hex7Seg_bgn:     CMP  R1  47       ;  Check if the number is in ascii form.
                 BLE  Hex7Seg_norm
                 SUB  R1  48       ;  It's ascii so subtract 48 to get decimal.
Hex7Seg_norm:    AND  R1  %01111   ;  R0 := R0 MOD 16 , just to be safe...
                LOAD  R2  [SP++]   ;  R1 := address(tbl) (retrieve from stack)
                LOAD  R2  [R2+R1]  ;  R1 := tbl[R0]
                 RTS

;---------------------------------------------------------------------------------;				 				 
				 
Alfa7Seg:      CMP  R1  32
               BNE  Alfa7Seg_ns
              LOAD  R2  0
               RTS
Alfa7Seg_ns:   CMP  R1 96
               BLE  Hex7Seg
               BRS  Alfa7Seg_bgn  ;  push address(tbl) onto stack and proceed at "bgn"
Alfa7Seg_tbl: CONS  %01110111    ;  7-segment pattern for 'a'
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
Alfa7Seg_bgn:  SUB  R1  97
			   MOD  R1  26   	 ;  R0 := R0 MOD 26 , just to be safe...
              LOAD  R2  [SP++]   ;  R1 := address(tbl) (retrieve from stack)
              LOAD  R2  [R2+R1]  ;  R1 := tbl[R0]
               RTS

update_display:
             PUSH  R0
			 PUSH  R1
			 PUSH  R2
             PUSH  R3
             PUSH  R4               ; R4 will store the start of the ascii array to display.
             
             LOAD  R0 GB
              ADD  R0 DSP_ASCII
             LOAD  R3 [GB+NXT_DSP]
              ADD  R3 1
             STOR  R3 [GB+NXT_DSP]
             DVMD  R3 100
              CMP  R4 0
              BNE  r_display
              CMP  R3 1
              BEQ  dsp_0
              CMP  R3 2
              BEQ  dsp_1
              CMP  R3 3
              BEQ  dsp_2
              CMP  R3 4
              BEQ  dsp_3
              CMP  R3 5
              BEQ  dsp_4
              CMP  R3 6
              BEQ  dsp_5
             LOAD  R3 1
             STOR  R3 [GB+NXT_DSP]
              BRA  r_display
             
dsp_0:		 LOAD  R1  [GB+DSP_DEC]				; load a copy of n into R0
              BPL  dsp_0_dec                    ; If n is positive, display a decimal number
             LOAD  R1  [R0+2]
              DIV  R1  %0100000000
              AND  R1  %011111111
              BRS  Alfa7Seg
              BRA  dsp_0_store
dsp_0_dec:	  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
dsp_0_store: STOR  R2  [R5+DSPSEG]		; set the displa code
			 LOAD  R1  %01				; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA  r_display
			 
dsp_1:	     LOAD  R1  [GB+DSP_DEC]				; load a copy of n into R0
			  BPL  dsp_1_dec                    ; If n is positive, display a decimal number
             LOAD  R1  [R0+2]
              AND  R1  %011111111
              BRS  Alfa7Seg
              BRA  dsp_1_store
dsp_1_dec:    DIV  R1  10				; bit shift right by 4
			  MOD  R1  10
              BRS  Hex7Seg				; get the display code of the last hex digit
dsp_1_store: STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %010				; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA  r_display
			  
dsp_2:       LOAD  R1  [GB+DSP_DEC]				; load a copy of n into R0
              BPL  dsp_2_dec                    ; If n is positive, display a decimal number
             LOAD  R1  [R0+1]
              DIV  R1  %0100000000
              AND  R1  %011111111
              BRS  Alfa7Seg
              BRA  dsp_2_store
dsp_2_dec:    DIV  R1  100				; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
dsp_2_store: STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %0100			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA  r_display
			 
dsp_3:		 LOAD  R1  [GB+DSP_DEC]				; load a copy of n into R0
              BPL  dsp_3_dec                    ; If n is positive, display a decimal number
             LOAD  R1  [R0+1]
              AND  R1  %011111111
              BRS  Alfa7Seg
              BRA  dsp_3_store
dsp_3_dec:    DIV  R1  1000
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
dsp_3_store: STOR  R2  [R5+DSPSEG]		; set the displa code
			 LOAD  R1  %01000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			 
dsp_4:		 LOAD  R1  [GB+DSP_DEC]				; load a copy of n into R0
			  BPL  dsp_4_dec                    ; If n is positive, display a decimal number
             LOAD  R1  [R0]
              DIV  R1  %0100000000
              AND  R1  %011111111
              BRS  Alfa7Seg
              BRA  dsp_4_store
dsp_4_dec:    DIV  R1  10000			; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
dsp_4_store: STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %010000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			  
dsp_5:		 LOAD  R1  [GB+DSP_DEC]				; load a copy of n into R0
              BPL  dsp_5_dec                    ; If n is positive, display a decimal number
             LOAD  R1  [R0]
              AND  R1  %011111111
              BRS  Alfa7Seg
              BRA  dsp_5_store			 
dsp_5_dec:    DIV  R1  100000			; bit shift right by 4
			  MOD  R1  10
			  BRS  Hex7Seg				; get the display code of the last hex digit
dsp_5_store: STOR  R2  [R5+DSPSEG]		; set the display code
			 LOAD  R1  %0100000			; select the right display digit
			 STOR  R1  [R5+DSPDIG]		; set the display digit
			  BRA r_display
			 
r_display:   PULL  R4
             PULL  R3
			 PULL  R2
			 PULL  R1
             PULL  R0
			 
			  RTS              
@END              