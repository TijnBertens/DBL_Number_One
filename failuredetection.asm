@CODE

check_engine_failure:
			PUSH  R0
			PUSH  R1
			PUSH  R2
             
			LOAD  R2  [R5+TIMER]
			 
            LOAD  R0  ' 2' 
			LOAD  R1  [GB+BTN_5_TS]
			 CMP  R1  -1
             BEQ  check_engine_failure_6
             SUB  R1  R2
			 CMP  R1  20000

			 BGT  error_state
			  
check_engine_failure_6:
			LOAD  R0  ' 0'
            LOAD  R1  [GB+BTN_6_TS]
			 SUB  R1  R2
			 CMP  R1  20000
             
			 BGT  error_state
			 
            LOAD  R0  ' 1'
			LOAD  R1  [GB+BTN_7_TS]
			 SUB  R1  R2
			 CMP  R1  30000
             
			 BGT  error_state
			 
             PULL  R2
			 PULL  R1
			 PULL  R0
			 RTS

			 
; INPUT: R0 = error code			 
error_state:
                           LOAD  R1  0
                           STOR  R1  [R5+OUTPUT]
                           STOR  R1  [GB+OUTPUTSTATE]
                           
                           LOAD  R1  -1
                           STOR  R1  [GB+BTN_5_TS]
                           STOR  R1  [GB+DSP_DEC]
                           LOAD  R1  'fa'
                           STOR  R1  [GB+DSP_ASCII]
                           LOAD  R1  'il'
                           STOR  R1  [GB+DSP_ASCII_1]
                           STOR  R0  [GB+DSP_ASCII_2]
                           
                            DIV  R1  %0100000000
                            AND  R1  %011111111
                            CMP  R0  49
                            BLE  error_state_while
                            
                           LOAD  R0  3
                           LOAD  R1  2
                            BRS  poll_inputs     
                            BRS  handle_btns
                            ;BRS  check_engine_failure
                            BRS  handle_scanners
                            BRS  update_display
                            BRS  check_pos
                            BRS  drive_motors1
				
                           STOR R0  [GB+TARGET_X]
                           STOR R1  [GB+TARGET_Y]
                           
                           LOAD R2  [GB+POS_X]
                           LOAD R3  [GB+POS_Y]
                           
                            CMP R2  R0					;if(x != tarx || y != tarY) => wait
                            BNE move_while_begin
                            CMP R3  R1
                            BNE move_while_begin
                           
error_state_while:         BRS  update_display
                           
                           BRS  poll_inputs
                          LOAD  R0  [GB+INPUTSTATE]
                           AND  R0  %010
                           CMP  R0  %010
                           BNE  error_state_while
                           BRA  reset
                           
                           BRA  error_state_while
@END