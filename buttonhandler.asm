@CODE
   
handle_btns: PUSH  R0
			 PUSH  R1
			 PUSH  R2
			 PUSH  R3
			 
			 LOAD  R0  [GB+PREVINPUTSTATE]
			 LOAD  R1  [GB+INPUTSTATE]
			  XOR  R0  R1
			  AND  R0  R1
			  
btn0tgl:	 LOAD  R1  R0				; check button 0 for toggle
			  AND  R1  %00000001
			  CMP  R1  %00000001
			  BNE  btn1tgl
			  BRS  button_0_toggled
			  
btn1tgl:	 LOAD  R1  R0				; check button 1 for toggle
			  AND  R1  %00000010
			  CMP  R1  %00000010
			  BNE  btn2tgl
			  BRS  button_1_toggled			  
			  
btn2tgl:	 LOAD  R1  R0				; check button 2 for toggle
			  AND  R1  %00000100
			  CMP  R1  %00000100
			  BNE  btn3tgl
			  BRS  button_2_toggled			  

btn3tgl:	 LOAD  R1  R0				; check button 3 for toggle
			  AND  R1  %00001000
			  CMP  R1  %00001000
			  BNE  btn4tgl
			  BRS  button_3_toggled			  
			  
btn4tgl:	 LOAD  R1  R0				; check button 4 for toggle
			  AND  R1  %00010000
			  CMP  R1  %00010000
			  BNE  btn5tgl
			  BRS  button_4_toggled			  

btn5tgl:	 LOAD  R1  R0				; check button 5 for toggle
			  AND  R1  %00100000
			  CMP  R1  %00100000
			  BNE  btn6tgl
			  BRS  button_5_toggled			  			  
			  
btn6tgl:	 LOAD  R1  R0				; check button 6 for toggle
			  AND  R1  %01000000
			  CMP  R1  %01000000
			  BNE  btn7tgl
			  BRS  button_6_toggled			  			  

btn7tgl:	 LOAD  R1  R0				; check button 7 for toggle
			  AND  R1  %0100000
			  CMP  R1  %0100000
			  BNE  r_handle_btns
			  BRS  button_7_toggled			  			  
			
r_handle_btns:
		     PULL  R3
			 PULL  R2
			 PULL  R1
			 PULL  R0
			  RTS
			  
;---------------------------------------------------------------------------------;	
			  
button_0_toggled:
			 RTS
			
;---------------------------------------------------------------------------------;	
			  
button_1_toggled:
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_2_toggled:
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_3_toggled:
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_4_toggled:
			 BRS  place_disk
			 RTS
;---------------------------------------------------------------------------------;	
			  
button_5_toggled:
			PUSH  R0						
			LOAD  R0  0						; turn off the disc placer motor
			STOR  R0  [GB+MOTORDIRECTION1]  ; which is motor 1
			PULL  R0
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_6_toggled:
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_7_toggled:
			 RTS			 
@END              