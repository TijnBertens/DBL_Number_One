@CODE

check_engine_failure:
			PUSH  R0
			PUSH  R1
			 
			LOAD  R1  [R5+TIMER]
			 
			LOAD  R0  [GB+BTN_5_TS]
			 SUB  R0  R1
			 CMP  R0  30000
			 BGT  error_state
			  
			LOAD  R0  [GB+BTN_6_TS]
			 SUB  R0  R1
			 CMP  R0  30000
			 BGT  error_state
			 
			LOAD  R0  [GB+BTN_7_TS]
			 SUB  R0  R1
			 CMP  R0  30000
			 BGT  error_state
			 
			 PULL  R1
			 PULL  R0
			 RTS

			 
			 
error_state:
			BRS  update_display
			BRA  error_state
@END