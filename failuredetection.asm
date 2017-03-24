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
				 
check_cheating_r:          BRS  check_cheating_color_diff
							CMP  R0  1
							BNE  check_cheating_r
						   LOAD  R0  ' 7'
						    BRA  error_state
							
						   PULL  R3
                           PULL  R2
                           PULL  R1
                           PULL  R0
                            RTS
;---------------------------------------------------------------------------------;
;OUTPUT: R0 contains 1 if there the difference was not equal to 1, 0 otherwise
check_cheating_color_diff:
						   PUSH  R0
						   PUSH  R1
						   PUSH  R2
						   PUSH  R3
						   PUSH  R4
							
							ADD  SP  4
						WHITE_COUNT    EQU  0
						BLACK_COUNT    EQU  1
						WHITE_COUNT_PREV  EQU  2
						BLACK_COUNT_PREV  EQU  3
							
						   LOAD  R3  0
						   LOAD  R4  GB
						    ADD  R4  GRID
						
						;----cur grid---;
color_diff_while:		   LOAD  R0  [R4]
						    CMP  R0  0
						    BEQ  color_diff_chk_cur_blc
						   LOAD  R1  [SP+WHITE_COUNT]
						    ADD  R1  1
						   STOR  R1  [SP+WHITE_COUNT]
						    BRA  color_diff_chk_prev_wht
							
color_diff_chk_cur_blc:		CMP  R0  2
							BEQ  color_diff_chk_prev_wht
						   LOAD  R1  [SP+BLACK_COUNT]
						    ADD  R1  1
						   STOR  R1  [SP+BLACK_COUNT]
							
						;----prev grid---;
color_diff_chk_prev_wht:   LOAD  R0  [R4+10]
						    CMP  R0  0
						    BEQ  color_diff_chk_prev_blc
						   LOAD  R1  [SP+WHITE_COUNT_PREV]
						    ADD  R1  1
						   STOR  R1  [SP+WHITE_COUNT_PREV]
						    BRA  color_diff_while_skip
							
color_diff_chk_prev_blc:	CMP  R0  2
							BEQ  color_diff_while_skip
						   LOAD  R1  [SP+BLACK_COUNT_PREV]
						    ADD  R1  1
						   STOR  R1  [SP+BLACK_COUNT_PREV]
						   
color_diff_while_skip:	    ADD  R3  1
							ADD  R4  1
							
							CMP  R3  8
							BLE  color_diff_while
						   
						   
						   LOAD  R1  [SP+WHITE_COUNT]
						   LOAD  R2  [SP+WHITE_COUNT_PREV]
						   LOAD  R3  [SP+BLACK_COUNT]
						   LOAD  R4  [SP+BLACK_COUNT_PREV]
						   
						    SUB  R1  R3
							CMP  R1  1
							BGT  check_cheating_color_diff_return_1
							CMP  R1  -1
							BLT  check_cheating_color_diff_return_1
							CMP  R1  0 
							BEQ  check_cheating_color_diff_return_1
							
						   LOAD  R0  0
							BRA  check_cheating_color_diff_r
							
check_cheating_color_diff_return_1:
						   LOAD  R0  1  
						   
check_cheating_color_diff_r:
						    SUB  SP  4
						   PULL  R4
						   PULL  R3
						   PULL  R2
						   PULL  R1
						   
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