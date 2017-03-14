@CODE
do_next_move:                  PUSH  R0 
                               PUSH  R1
                               
                               LOAD  R0  2
                                BRS  check_can_win_block
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                               LOAD  R0  0
                                BRS  check_can_win_block
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                                BRS  check_forks
                                
do_next_move_r:                LOAD  R0  3
                               LOAD  R1  2
                                BRS  move_to_pos
                                
                               PULL  R1
                               PULL  R0
                                RTS
;---------------------------------------------------------------------------------;		
; INPUT: R0 = color. So 2 to check for win, 0 to check for block                                
check_can_win_block:          PUSH  R1

                              ; Check rows
                              LOAD  R1  R0
                              LOAD  R0  0
                               BRS  check_row
                               CMP  R0  -1
                               BEQ  check_can_win_r
                               
                              LOAD  R0  1
                               BRS  check_row
                               CMP  R0  -1
                               BEQ  check_can_win_r
                               
                              LOAD  R0  2
                               BRS  check_row
                               CMP  R0  -1
                               BEQ  check_can_win_r
                               
                              ; Check cols
                              LOAD  R0  0
                               BRS  check_col
                               CMP  R0  -1
                               BEQ  check_can_win_r
                               
                              LOAD  R0  1
                               BRS  check_col
                               CMP  R0  -1
                               BEQ  check_can_win_r
                               
                              LOAD  R0  2
                               BRS  check_col
                               CMP  R0  -1
                               BEQ  check_can_win_r
                               
                               BRS  check_diag1
                               CMP  R0  -1
                               BEQ  check_can_win_r
                               
                               BRS  check_diag2
                               CMP  R0  -1
                               BEQ  check_can_win_r
                               
                               
                               
                
check_can_win_r:              PULL  R1
                               RTS 



;---------------------------------------------------------------------------------;		
; INPUT: R0 = y
;        R1 = color
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.
check_row:                     PUSH  R1
                               PUSH  R2
                               PUSH  R3
                               
                               LOAD  R3  GB
                                ADD  R3  GRID
                               PUSH  R3
                               
                               LOAD  R2  R0
                               MULS  R2  3
                                ADD  R2  0
                               LOAD  R0  [[SP]+R2]
                                
                               LOAD  R3  0              ; R3 = color counter
                               LOAD  R4  0              ; R4 = empty counter
                                CMP  R0  R1     
                                BNE  check_row_check_empty1
                                ADD  R3  1
                                BRA  check_row_color2
                                
check_row_check_empty1:         CMP  R0  1
                                BNE  check_row_color2
                                ADD  R4  1
                                
check_row_color2:               ADD  R2  1
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_row_check_empty2
                                ADD  R3  1
                                BRA  check_row_color3
                                
check_row_check_empty2:         CMP  R0  1
                                BNE  check_row_color3
                                ADD  R4  1                                 
                                
check_row_color3:               ADD  R2  1
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_row_check_empty3
                                ADD  R3  1
                                BRA  check_row_count_colors
                                
check_row_check_empty3:         CMP  R0  1
                                BNE  check_row_count_colors
                                ADD  R4  1                                    

                              
check_row_count_colors:          
                                CMP  R3  2
                                BNE  check_row_r
                                CMP  R4  1
                                BNE  check_row_r
                                
                                CMP  R0  1
                                BEQ  check_row_return_empty
                               
                                SUB  R2  1
                               LOAD  R0  [[SP]+R2]
                                CMP  R0  1
                                BEQ  check_row_return_empty

                                SUB  R2  1
                               LOAD  R0  [[SP]+R2]
                                CMP  R0  1
                                BNE  check_row_r
                                
check_row_return_empty:        LOAD  R0  R2
                                BRS  do_move      
                               LOAD  R0  -1
                                
check_row_r:                    ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS
;---------------------------------------------------------------------------------;		                                
; INPUT: R0 = x
;        R1 = color
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.
check_col:                     PUSH  R1
                               PUSH  R2
                               PUSH  R3
                               
                               LOAD  R3  GB
                                ADD  R3  GRID
                               PUSH  R3
                               
                               LOAD  R2  R0
                               LOAD  R0  [[SP]+R2]
                                
                               LOAD  R3  0              ; R3 = color counter
                               LOAD  R4  0              ; R4 = empty counter
                                CMP  R0  R1     
                                BNE  check_col_check_empty1
                                ADD  R3  1
                                BRA  check_col_color2
                                
check_col_check_empty1:         CMP  R0  1
                                BNE  check_col_color2
                                ADD  R4  1
                                
check_col_color2:               ADD  R2  3
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_col_check_empty2
                                ADD  R3  1
                                BRA  check_col_color3
                                
check_col_check_empty2:         CMP  R0  1
                                BNE  check_col_color3
                                ADD  R4  1                                 
                                
check_col_color3:               ADD  R2  3
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_col_check_empty3
                                ADD  R3  1
                                BRA  check_col_count_colors
                                
check_col_check_empty3:         CMP  R0  1
                                BNE  check_col_count_colors
                                ADD  R4  1                                    

                              
check_col_count_colors:          
                                CMP  R3  2
                                BNE  check_col_r
                                CMP  R4  1
                                BNE  check_col_r
                                
                                CMP  R0  1
                                BEQ  check_col_return_empty
                               
                                SUB  R2  3
                               LOAD  R0  [[SP]+R2]
                                CMP  R0  1
                                BEQ  check_col_return_empty

                                SUB  R2  3
                               LOAD  R0  [[SP]+R2]
                                CMP  R0  1
                                BNE  check_col_r
                                
check_col_return_empty:        LOAD  R0  R2
                                BRS  do_move      
                               LOAD  R0  -1
                                
check_col_r:                    ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS

;---------------------------------------------------------------------------------;		                                
; INPUT:  R1 = color
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.
check_diag1:                   PUSH  R1
                               PUSH  R2
                               PUSH  R3
                               
                               LOAD  R3  GB
                                ADD  R3  GRID
                               PUSH  R3
                               
                               LOAD  R2  0
                               LOAD  R0  [[SP]+R2]
                                
                               LOAD  R3  0              ; R3 = color counter
                               LOAD  R4  0              ; R4 = empty counter
                                CMP  R0  R1     
                                BNE  check_diag1_check_empty1
                                ADD  R3  1
                                BRA  check_diag1_color2
                                
check_diag1_check_empty1:       CMP  R0  1
                                BNE  check_diag1_color2
                                ADD  R4  1
                                
check_diag1_color2:             ADD  R2  4
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_diag1_check_empty2
                                ADD  R3  1
                                BRA  check_diag1_color3
                                
check_diag1_check_empty2:       CMP  R0  1
                                BNE  check_diag1_color3
                                ADD  R4  1                                 
                                
check_diag1_color3:             ADD  R2  4
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_diag1_check_empty3
                                ADD  R3  1
                                BRA  check_diag1_count_colors
                                
check_diag1_check_empty3:       CMP  R0  1
                                BNE  check_diag1_count_colors
                                ADD  R4  1                                    

                              
check_diag1_count_colors:          
                                CMP  R3  2
                                BNE  check_diag1_r
                                CMP  R4  1
                                BNE  check_diag1_r
                                
                                CMP  R0  1
                                BEQ  check_diag1_return_empty
                               
                                SUB  R2  4
                               LOAD  R0  [[SP]+R2]
                                CMP  R0  1
                                BEQ  check_diag1_return_empty

                                SUB  R2  4
                               LOAD  R0  [[SP]+R2]
                                CMP  R0  1
                                BNE  check_diag1_r
                                
check_diag1_return_empty:      LOAD  R0  R2
                                BRS  do_move      
                               LOAD  R0  -1
                                
check_diag1_r:                  ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS
;---------------------------------------------------------------------------------;		                                
; INPUT:  R1 = color
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.
check_diag2:                   PUSH  R1
                               PUSH  R2
                               PUSH  R3
                               
                               LOAD  R3  GB
                                ADD  R3  GRID
                               PUSH  R3
                               
                               LOAD  R2  2
                               LOAD  R0  [[SP]+R2]
                                
                               LOAD  R3  0              ; R3 = color counter
                               LOAD  R4  0              ; R4 = empty counter
                                CMP  R0  R1     
                                BNE  check_diag2_check_empty1
                                ADD  R3  1
                                BRA  check_diag2_color2
                                
check_diag2_check_empty1:       CMP  R0  1
                                BNE  check_diag2_color2
                                ADD  R4  1
                                
check_diag2_color2:             ADD  R2  2
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_diag2_check_empty2
                                ADD  R3  1
                                BRA  check_diag2_color3
                                
check_diag2_check_empty2:       CMP  R0  1
                                BNE  check_diag2_color3
                                ADD  R4  1                                 
                                
check_diag2_color3:             ADD  R2  2
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_diag2_check_empty3
                                ADD  R3  1
                                BRA  check_diag2_count_colors
                                
check_diag2_check_empty3:       CMP  R0  1
                                BNE  check_diag2_count_colors
                                ADD  R4  1                                    

                              
check_diag2_count_colors:          
                                CMP  R3  2
                                BNE  check_diag2_r
                                CMP  R4  1
                                BNE  check_diag2_r
                                
                                CMP  R0  1
                                BEQ  check_diag2_return_empty
                               
                                SUB  R2  2
                               LOAD  R0  [[SP]+R2]
                                CMP  R0  1
                                BEQ  check_diag2_return_empty

                                SUB  R2  2
                               LOAD  R0  [[SP]+R2]
                                CMP  R0  1
                                BNE  check_diag2_r
                                
check_diag2_return_empty:      LOAD  R0  R2
                                BRS  do_move      
                               LOAD  R0  -1
                                
check_diag2_r:                  ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS                   
;---------------------------------------------------------------------------------;		                                
check_forks:                    BRS  check_forks_diag
                                RTS

check_forks_diag:              PUSH  R0
                               PUSH  R1

                                BRS  encode_grid        ; Returns in R0
                               LOAD  R1  [GB+FORK_DIAG0]
                                AND  R0  R1
                                CMP  R0  R1
                                BNE  check_forks_diag_r
                   
                               LOAD  R1  GB
                                ADD  R1  FORK_DIAG0
                               LOAD  R0  [R1+1]
                                BRS  do_move
                                
                   
check_forks_diag_r:            PULL  R1
                               PULL  R0
                                RTS
;---------------------------------------------------------------------------------;		                                
                                
do_move:                       PUSH  R0
                               PUSH  R1
                               PUSH  R2
                               
                               LOAD  R2  R0
                                MOD  R0  3
                                DIV  R2  3
                               LOAD  R1  R2
                                BRS  move_to_pos
                                BRS  place_disk
                                
                                ; TODO check correctness of placed disk

                               PULL  R2
                               PULL  R1
                               PULL  R0
                                RTS
;---------------------------------------------------------------------------------;		                                
;INPUT: R0 = wanted color
;OUTPUT R0 = current grid encoded in one word, aka 18 bits.
encode_grid:                   PUSH  R0
                               PUSH  R1
                               PUSH  R2
                               PUSH  R3
                               
                               LOAD  R0  GB
                                ADD  R0  GRID
                               PUSH  R0
                               
                               LOAD  R2  R0
                               LOAD  R1  0
                               
encode_grid_for:               LOAD  R3  [[SP]+R1]
                                
                                CMP  R3  1  
                                BEQ  encode_grid_for_add
                                
                                CMP  R3  R0
                                BEQ  encode_grid_for_11
                                
                               LOAD  R3  %10
                                BRA  encode_grid_for_add

encode_grid_for_11:            LOAD  R3  %11                    
encode_grid_for_add:             OR  R0  R3
                                    
                                CMP  R1  8
                                BEQ  encode_grid_for_skip
                               MULS  R1  %100
                                
encode_grid_for_skip:           ADD  R1  1
                                CMP  R1  8
                                BLE  encode_grid_for
                               
                                SUB  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                               PULL  R0
                                RTS
;---------------------------------------------------------------------------------;		                                                                
@END