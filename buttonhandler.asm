@CODE
   
handle_btns: PUSH  R0
			 PUSH  R1
			 PUSH  R2
			 PUSH  R3
			 
			 LOAD  R0  [GB+PREVINPUTSTATE]
			 LOAD  R1  [GB+INPUTSTATE]
			  XOR  R0  R1
			  AND  R0  R1
              
             LOAD  R2  [GB+IS_BUSY]
              CMP  R2  0
              BEQ  btn0tgl
              
              AND  R0  %11100001
			  
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
             
             LOAD  R2  [GB+IS_BUSY]
              CMP  R2  0
              BEQ  btn0hld
              AND  R0  %11100001

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
			  BNE  btn2up
			  BRS  button_2_down	

btn2up:      LOAD  R1  R0
             LOAD  R2  [GB+PREVINPUTSTATE]
              XOR  R1  %1
              XOR  R2  %1
              XOR  R2  R1
              AND  R2  R1
              AND  R1  %00000100
              CMP  R1  0
              BNE  btn3hld
              BRS  button_2_up

btn3hld:	 LOAD  R1  R0				; check button 3 for toggle
			  AND  R1  %00001000
			  CMP  R1  %00001000
			  BNE  btn3up
			  BRS  button_3_down			  
			  
btn3up:      LOAD  R1  R0
             LOAD  R2  [GB+PREVINPUTSTATE]
              XOR  R1  %1
              XOR  R2  %1
              XOR  R2  R1
              AND  R2  R1
              AND  R1  %000001000
              CMP  R1  0
              BNE  btn4hld
              BRS  button_3_up              
              
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
            
            LOAD  R0  [R5+INPUT]
             AND  R0  %01000000
             CMP  R0  %01000000
             BEQ  check_y_pushed
             
            LOAD  R0  [GB+MOTORDIRECTION0]
             CMP  R0  -1
             BNE  check_y_pushed
             
            LOAD  R0  [GB+POS_X]
             SUB  R0  1
            STOR  R0  [GB+POS_X]
             
check_y_pushed:             
            LOAD  R0  [R5+INPUT]
             AND  R0  %010000000
             CMP  R0  %010000000
             BEQ  button_0_toggled_r
             
            LOAD  R0  [GB+MOTORDIRECTION2]
             CMP  R0  -1
             BNE  button_0_toggled_r
             
            LOAD  R0  [GB+POS_Y]
             SUB  R0  1
            STOR  R0  [GB+POS_Y]
             
button_0_toggled_r:
            LOAD  R0  ' e'
             BRA  error_state
            
            PULL  R0
			 RTS
			
;---------------------------------------------------------------------------------;	
			  
button_1_toggled:       ; Checked in error state.
			 BRA  reset
             RTS

;---------------------------------------------------------------------------------;	
			  
button_2_toggled:       ;  Used to move motor back in down/up.
			 RTS

;---------------------------------------------------------------------------------;	
			  
button_3_toggled:
;            PUSH  R0
;            LOAD  R0  %10000000
;            STOR  R0  [R5+OUTPUT]
;            STOR  R0  [GB+OUTPUTSTATE]
;pause_while: BRS  update_display 
;            LOAD  R0  [R5+INPUT]
;			 AND  R0  %01000
;			 CMP  R0  %01000
;			 BEQ  pause_while
;            PULL  R0
			; player light off
			RTS

;---------------------------------------------------------------------------------;	
			  
button_4_toggled:
            PUSH  R0
            
			; player light off
			LOAD  R0  [GB+OUTPUTSTATE]
			 AND  R0  %10111111
			STOR  R0  [GB+OUTPUTSTATE]
            
            LOAD  R0  1
            STOR  R0  [GB+IS_BUSY]
			
             BRS  scan_grid
             BRS  do_next_move
            
			; turn player light on
			LOAD  R0  [GB+OUTPUTSTATE]
			  OR  R0  %01000000
			STOR  R0  [GB+OUTPUTSTATE]
			
            PULL  R0
			 RTS
;---------------------------------------------------------------------------------;	
			  
button_5_toggled:
			PUSH  R0						
			LOAD  R0  0						; turn off the disc placer motor
			STOR  R0  [GB+MOTORDIRECTION1]  ; which is motor 1
            LOAD  R1  -1
            STOR  R1  [GB+BTN_5_TS]
			PULL  R0
			 RTS

;---------------------------------------------------------------------------------;	
			  
;This is the button that is attatched to motor0 (x-axis);
button_6_toggled:
			PUSH  R0				
            
			LOAD  R0  [GB+POS_X]
			 ADD  R0  [GB+MOTORDIRECTION0]
			STOR  R0  [GB+POS_X]
            
            LOAD  R0  [R5+TIMER]
			STOR  R0  [GB+BTN_6_TS]
            
			PULL  R0
			 RTS

;---------------------------------------------------------------------------------;	

;This is the button that is attatched to motor2 (y-axis);			  
button_7_toggled:
			PUSH  R0
            
			LOAD  R0  [GB+POS_Y]
			 ADD  R0  [GB+MOTORDIRECTION2]
			STOR  R0  [GB+POS_Y]
            
            LOAD  R0  [R5+TIMER]
			STOR  R0  [GB+BTN_7_TS]
            
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
			PUSH  R0  
            
            LOAD  R0  1
            STOR  R0  [GB+MOTORDIRECTION0]
            LOAD  R0  0
            STOR  R0  [GB+MOTORDIRECTION1]
            STOR  R0  [GB+MOTORDIRECTION2]
            
button_2_down_while:
             BRS  drive_motors1
            LOAD  R0  [R5+INPUT]
             AND  R0  %0100
             CMP  R0  0
             BNE  button_2_down_while
            
            PULL  R0
             RTS

;---------------------------------------------------------------------------------;				 
			 
button_3_down:
            PUSH  R0  
            
            LOAD  R0  1
            STOR  R0  [GB+MOTORDIRECTION2]
            LOAD  R0  0
            STOR  R0  [GB+MOTORDIRECTION0]
            STOR  R0  [GB+MOTORDIRECTION1]
            
button_3_down_while:
             BRS  drive_motors1
            LOAD  R0  [R5+INPUT]
             AND  R0  %01000
             CMP  R0  0
             BNE  button_3_down_while
            
            PULL  R0
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_4_down:
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_5_down:
			 RTS

;---------------------------------------------------------------------------------;				 
			 
button_6_down:
			PUSH  R0
            
            LOAD  R0  [GB+MOTORDIRECTION0]
             CMP  R0  0
             BNE  button_6_down_r
            
            LOAD  R0  [R5+TIMER]
			STOR  R0  [GB+BTN_6_TS]

button_6_down_r:
            PULL  R0
			 RTS			 
			 

;---------------------------------------------------------------------------------;				 
			 
button_7_down:
			PUSH  R0
            
            LOAD  R0  [GB+MOTORDIRECTION2]
             CMP  R0  0
             BNE  button_7_down_r
            
			LOAD  R0  [R5+TIMER]
			STOR  R0  [GB+BTN_7_TS]
			
button_7_down_r:            
            PULL  R0
			 RTS			 
;---------------------------------------------------------------------------------;	
button_2_up:
            PUSH  R0  
            
            LOAD  R0  0
            STOR  R0  [GB+MOTORDIRECTION0]
            
            PULL  R0
             RTS
;---------------------------------------------------------------------------------;	
button_3_up:
            PUSH  R0  
            
            LOAD  R0  0
            STOR  R0  [GB+MOTORDIRECTION2]
            
            PULL  R0
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