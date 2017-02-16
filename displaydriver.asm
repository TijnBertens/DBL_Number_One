@CODE
display_decimal_number:
			 PUSH  R1
			 PUSH  R2
             PUSH  R3
             
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
@END              