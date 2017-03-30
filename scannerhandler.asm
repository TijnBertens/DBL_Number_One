@CODE

scan_current_position:
			 PUSH  R0
			 PUSH  R1	
			 PUSH  R2
			 
			 LOAD  R0  [GB+POS_X]
			 LOAD  R1  [GB+POS_Y]
			 
			 MULS  R1  3
			  ADD  R0  R1					; R0 := x + 3y
			  
			 LOAD  R1  [GB+SCANNEDCOLOR]
             LOAD  R2  [GB+ANALOG0]
             ;MULS  R1  1000
              ;ADD  R1  R2
			 LOAD  R2  GB
			  ADD  R2  GRID					; R2 := GB+GRID
			 STOR  R1  [R2+R0]				; RAM[GB+GRID+OFFSET] := SCANNEDCOLOR
			 
             LOAD  R2  [GB+ANALOG0]
             MULS  R1  1000
              ADD  R1  R2
             STOR  R1  [GB+DSP_DEC]
             
			 PULL  R2
			 PULL  R1
			 PULL  R0
			  RTS

handle_scanners:
             PUSH  R0
			 PUSH  R1
			 
			 LOAD  R0  [GB+SCANNEDCOLOR]
			 STOR  R0  [GB+PREVSCANNEDCOLOR]	; update the previous scanned color
			 
			 LOAD  R0  [GB+ANALOG0]
			 
chk_white:	  CMP  R0  [GB+WHITE_VALUE]			; ANALOG0 <= 75 => scanned_color = white
			  BGE  chk_black 
			 LOAD  R1  0
			 STOR  R1  [GB+SCANNEDCOLOR] 
			  BRA  chk_scn_chg
			 
chk_black:	  CMP  R0  [GB+BLACK_VALUE]			; ANALOG0 >= 200 => scanned_color = black
			  BLE  st_bg 
			 LOAD  R1  2
			 STOR  R1  [GB+SCANNEDCOLOR] 
			  BRA  chk_scn_chg
			 
st_bg:		 LOAD  R1  1						; ANALOG0 > 50 && ANALOG0 < 200
			 STOR  R1  [GB+SCANNEDCOLOR]		;	=> scanned_color = background
			 
			 
chk_scn_chg: LOAD  R0  R1						; DEBUG:
			 MULS  R0  10000					; display ANALOG0 and scannedcolor
			  ADD  R0  [GB+ANALOG0]				; on the display
			  ;BRS  display_decimal_number
			  
			 LOAD  R0  [GB+PREVSCANNEDCOLOR]	; if new color != prevcolor
			  CMP  R0  R1						; call "scanned_color_changed"
			  BEQ  r_hndls_scn
			  BRS  scanned_color_changed
			 
r_hndls_scn: PULL  R1
			 PULL  R0
			  RTS

;---------------------------------------------------------------------------------;	

scanned_color_changed:
			  RTS			
			  
;---------------------------------------------------------------------------------;	

do_calibration_round:
				PUSH  R0
				PUSH  R1
				PUSH  R2
				PUSH  R3
				PUSH  R4

				LOAD  R2  0			; sum of black values
				LOAD  R3  0			; sum of bg values
				LOAD  R4  0			; sum of white values
				
				LOAD  R0  2
				LOAD  R1  2
				 BRS  move_to_pos
                PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
				LOAD  R0  [GB+ANALOG0]
				 ADD  R2  R0
                
                 ;BRS  sleep
				 
				LOAD  R0  1
				LOAD  R1  2
				 BRS  move_to_pos
                PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
				LOAD  R0  [GB+ANALOG0]
				 ADD  R2  R0
				 
				LOAD  R0  0
				LOAD  R1  2
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
				LOAD  R0  [GB+ANALOG0]
				 ADD  R2  R0
				
				LOAD  R0  0
				LOAD  R1  1
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
				LOAD  R0  [GB+ANALOG0]
				 ADD  R3  R0
				
				
				LOAD  R0  0
				LOAD  R1  0
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
				LOAD  R0  [GB+ANALOG0]
				 ADD  R3  R0
				
				LOAD  R0  1
				LOAD  R1  0
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
                LOAD  R0  [GB+ANALOG0]
				 ADD  R3  R0
				
				LOAD  R0  2
				LOAD  R1  0
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
				LOAD  R0  [GB+ANALOG0]
				 ADD  R4  R0
				
				
				LOAD  R0  2
				LOAD  R1  1
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
				LOAD  R0  [GB+ANALOG0]
				 ADD  R2  R0
				LOAD  R0  [GB+ANALOG0]
				 ADD  R4  R0
				
				LOAD  R0  1
				LOAD  R1  1
				 BRS  move_to_pos
                 PUSH  R0
                LOAD  R0  2500 
                BRS  sleep_i		
                PULL  R0
                 BRS  color_dsp
				LOAD  R0  [GB+ANALOG0]
				 ADD  R4  R0
				 
				 
				 DIV  R2  3		; average black
				 DIV  R3  3		; average bg
				 DIV  R4  3		; average white
				 
                LOAD  R0  R2	;halfway between black and bg
				 ADD  R0  R3
                 ADD  R0  R3
				 DIV  R0  3
				 
				STOR  R0  [GB+BLACK_VALUE]
				STOR  R0  [GB+DSP_DEC]
				
				LOAD  R0  5000 
                BRS  sleep_i		
				
				LOAD  R0  R3	;halfway between bg and white
				 ADD  R0  R3
                 ADD  R0  R4
				 DIV  R0  3
				 
				STOR  R0  [GB+WHITE_VALUE]
				STOR  R0  [GB+DSP_DEC]
				
				LOAD  R0  5000 
                BRS  sleep_i		
				
				LOAD  R0  3
				LOAD  R1  2
				 BRS  move_to_pos
				
				PULL  R4
				PULL  R3
                PULL  R2
				PULL  R1
				PULL  R0
				 RTS
			  
@END