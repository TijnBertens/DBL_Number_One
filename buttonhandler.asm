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
			  AND  R1  %010000000
			  CMP  R1  %010000000
			  BNE  btns_down
			  BRS  button_7_toggled

;now functions for holding down;

btns_down:	 LOAD  R0  [GB+INPUTSTATE]

btn0hld:	 LOAD  R1  R0				; check button 0 for toggle
			  AND  R1  %00000001
			  CMP  R1  %00000001
			  BNE  btn1hld
			  BRS  button_0_down
			  
btn1hld:	 LOAD  R1  R0				; check button 1 for toggle
			  AND  R1  %00000010
			  CMP  R1  %00000010
			  BNE  btn2hld
			  BRS  button_1_down			  
			  
btn2hld:	 LOAD  R1  R0				; check button 2 for toggle
			  AND  R1  %00000100
			  CMP  R1  %00000100
			  BNE  btn3hld
			  BRS  button_2_down			  

btn3hld:	 LOAD  R1  R0				; check button 3 for toggle
			  AND  R1  %00001000
			  CMP  R1  %00001000
			  BNE  btn4hld
			  BRS  button_3_down			  
			  
btn4hld:	 LOAD  R1  R0				; check button 4 for toggle
			  AND  R1  %00010000
			  CMP  R1  %00010000
			  BNE  btn5hld
			  BRS  button_4_down			  

btn5hld:	 LOAD  R1  R0				; check button 5 for toggle
			  AND  R1  %00100000
			  CMP  R1  %00100000
			  BNE  btn6hld
			  BRS  button_5_down			  			  
			  
btn6hld:	 LOAD  R1  R0				; check button 6 for toggle
			  AND  R1  %01000000
			  CMP  R1  %01000000
			  BNE  btn7hld
			  BRS  button_6_down			  			  

btn7hld:	 LOAD  R1  R0				; check button 7 for toggle
			  AND  R1  %010000000
			  CMP  R1  %010000000
			  BNE  r_handle_btns
			  BRS  button_7_down		  			  
			  
			
r_handle_btns:
		     PULL  R3
			 PULL  R2
			 PULL  R1
			 PULL  R0
			  RTS
			  
;---------------------------------------------------------------------------------;	
			  
button_0_toggled:
            PUSH  R0
            LOAD  R0  3
            STOR  R0  [GB+TARGET_X]
            LOAD  R0  2
            STOR  R0  [GB+TARGET_Y]
            PULL  R0
			 RTS
			
;---------------------------------------------------------------------------------;	
			  
button_1_toggled:
            PUSH  R0
             BRS  place_disk
            PULL  R0
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_2_toggled:
             ;BRS  place_disk
             BRS scan_grid
;            PUSH  R0
;            LOAD  R0  [GB+MOTORDIRECTION2]
;             BRS  toggle_dir
;            STOR  R0  [GB+MOTORDIRECTION2]
;            PULL  R0
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_3_toggled:
            PUSH  R0
            LOAD  R0  %10000000
            STOR  R0  [R5+OUTPUT]
            STOR  R0  [GB+OUTPUTSTATE]
pause_while: BRS  update_display 
            LOAD  R0  [R5+INPUT]
			 AND  R0  %01000
			 CMP  R0  %01000
			 BEQ  pause_while
            PULL  R0
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_4_toggled:
            PUSH  R0
            
             BRS  scan_grid
             BRS  do_next_move
            
            PULL  R0
			 RTS
;---------------------------------------------------------------------------------;	
			  
button_5_toggled:
			PUSH  R0						
			LOAD  R0  0						; turn off the disc placer motor
			STOR  R0  [GB+MOTORDIRECTION1]  ; which is motor 1
			PULL  R0
			 RTS

;---------------------------------------------------------------------------------;	
			  
;This is the button that is attatched to motor0 (x-axis);
button_6_toggled:
			PUSH  R0						
			LOAD  R0  [GB+POS_X]
			 ADD  R0  [GB+MOTORDIRECTION0]
			STOR  R0  [GB+POS_X]
			PULL  R0
			 RTS

;---------------------------------------------------------------------------------;	

;This is the button that is attatched to motor2 (y-axis);			  
button_7_toggled:
			PUSH  R0
			LOAD  R0  [GB+POS_Y]
			 ADD  R0  [GB+MOTORDIRECTION2]
			STOR  R0  [GB+POS_Y]
			PULL  R0
			 RTS	
			 
;---------------------------------------------------------------------------------;				 
			 
button_0_down:
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_1_down:
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_2_down:
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_3_down:
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_4_down:
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_5_down:
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_6_down:
			 RTS			 
			 

;---------------------------------------------------------------------------------;				 
			 
button_7_down:
			 RTS			 
;---------------------------------------------------------------------------------;	
		

		
;---------------------------------------------------------------------------------;
;INPUT: R0 containing current direction. 
;OUTPUT: R0 containing toggled direction.
;---------------------------------------------------------------------------------;
toggle_dir:   CMP  R0 0
              BLE  dir_add
             LOAD  R0 -1
              RTS
dir_add:      ADD  R0 1             
              RTS             
@END              