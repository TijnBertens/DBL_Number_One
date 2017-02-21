@CODE

handle_scanners:
             PUSH  R0
			 PUSH  R1
			 
			 LOAD  R0  [GB+SCANNEDCOLOR]
			 STOR  R0  [GB+PREVSCANNEDCOLOR]
			 
			 LOAD  R0  [GB+ANALOG0]
			 
chk_white:	  CMP  R0  49
			  BGE  chk_black 
			 LOAD  R1  0
			 STOR  R1  [GB+SCANNEDCOLOR] 
			  BRA  chk_scn_chg
			 
chk_black:	  CMP  R0  199
			  BLE  st_bg 
			 LOAD  R1  2
			 STOR  R1  [GB+SCANNEDCOLOR] 
			  BRA  chk_scn_chg
			 
st_bg:		 LOAD  R1  1
			 STOR  R1  [GB+SCANNEDCOLOR]  
			 
			 
chk_scn_chg: LOAD  R0  R1
			 MULS  R0  10000
			  ADD  R0  [GB+ANALOG0]
			  BRS  display_decimal_number
			  
			 LOAD  R0  [GB+PREVSCANNEDCOLOR]
			  CMP  R0  R1
			  BEQ  r_hndls_scn
			  BRS  scanned_color_changed
			 
r_hndls_scn: PULL  R1
			 PULL  R0
			  RTS

;---------------------------------------------------------------------------------;	

scanned_color_changed:
			  RTS			
			  
@END