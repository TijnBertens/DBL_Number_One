@CODE

handle_scanners:
             PUSH  R0
			 PUSH  R1
			 
			 LOAD  R0  [GB+SCANNEDCOLOR]
			 STOR  R0  [GB+PREVSCANNEDCOLOR]	; update the previous scanned color
			 
			 LOAD  R0  [GB+ANALOG0]
			 
chk_white:	  CMP  R0  50						; ANALOG0 <= 50 => scanned_color = white
			  BGE  chk_black 
			 LOAD  R1  0
			 STOR  R1  [GB+SCANNEDCOLOR] 
			  BRA  chk_scn_chg
			 
chk_black:	  CMP  R0  200						; ANALOG0 >= 200 => scanned_color = black
			  BLE  st_bg 
			 LOAD  R1  2
			 STOR  R1  [GB+SCANNEDCOLOR] 
			  BRA  chk_scn_chg
			 
st_bg:		 LOAD  R1  1						; ANALOG0 > 50 && ANALOG0 < 200
			 STOR  R1  [GB+SCANNEDCOLOR]		;	=> scanned_color = background
			 
			 
chk_scn_chg: LOAD  R0  R1						; DEBUG:
			 MULS  R0  10000					; display ANALOG0 and scannedcolor
			  ADD  R0  [GB+ANALOG0]				; on the display
			  BRS  display_decimal_number
			  
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
			  
@END