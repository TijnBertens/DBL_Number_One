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
			 CMP  R1  30000
             
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
;---------------------------------------------------------------------------------;
check_cheating:            PUSH  R0         ; 
                           PUSH  R1         ; counter
                           PUSH  R2         ; grid pointer
                           PUSH  R3         ; amount of differences
                           
                           LOAD  R1  0
                           LOAD  R3  0
                           
                           LOAD  R2  GB
                            ADD  R2  GRID
                            
check_cheating_for:        LOAD  R0  [R2]
                            CMP  R0  [R2+10]
                            BEQ  check_cheating_skip
                            
                           LOAD  R0  [R2+10]
                            CMP  R0  1
                            BEQ  check_cheating_add
                            
                           LOAD  R0  ' 6'
                            BRA  error_state
                            
check_cheating_add:         ADD  R3  1                    

check_cheating_skip:        ADD  R2  1
                            ADD  R1  1
                            CMP  R1  9
                            BLT  check_cheating_for

                            CMP  R3  1
                            BEQ  check_cheating_r
                            
                            CMP  R3  0
                            BNE  check_cheating_err
                            
                           LOAD  R0  [GB+IS_FIRST_MOVE]
                            CMP  R0  1
                            BEQ  check_cheating_r

check_cheating_err:        LOAD  R0  ' 5'
                            BRA  error_state
                 
check_cheating_r:          PULL  R3
                           PULL  R2
                           PULL  R1
                           PULL  R0
                            RTS
;---------------------------------------------------------------------------------;
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
                           
                            DIV  R0  %0100000000
                            AND  R0  %011111111
                            CMP  R0  49             ; ...
                            BLE  error_state_while
                            
                           LOAD  R0  3
                           LOAD  R1  2
                            BRS  move_to_pos
                           
error_state_while:         BRS  update_display
                          LOAD  R0  0
                          STOR  R0  [R5+OUTPUT]
                          STOR  R0  [GB+OUTPUTSTATE]
                           
                           BRS  poll_inputs
                          LOAD  R0  [GB+INPUTSTATE]
                           AND  R0  %010
                           CMP  R0  %010
                           BNE  error_state_while
                           BRA  reset
                           
                           BRA  error_state_while
@END