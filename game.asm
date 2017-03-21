@CODE
do_next_move:                  PUSH  R0 
                               PUSH  R1
							   
                               LOAD  R0  2                  ; Load R0 to check for win
                                BRS  check_can_win_block
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                               LOAD  R0  0                  ; Load R0 to check for block
                                BRS  check_can_win_block
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                               LOAD  R0  2                  ; Load R0 to check for own fork
                                BRS  check_forks
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                               LOAD  R0  0                  ; Load R0 to check for opponent fork
                                BRS  check_forks
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                                BRS  check_center           ;  Check whether center is empty
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                                BRS  check_opposite_corners ;  Check opposite corners
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                                BRS  check_empty_corner     ;  Check whether there is an empty corner
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
                                BRS  check_empty_side       ;  Check whether there's an empty middle in edge
                                CMP  R0  -1
                                BEQ  do_next_move_r
                                
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
                               
                               ; Check diagnals
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
; INPUT:  R0 = color
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.	                                
check_forks:              
                               PUSH  R1                     ; R1 will keep a copy of the current fork being checked
                               PUSH  R2                     ; R2 will store the pointer to the current fork in RAM
                               PUSH  R3
                               PUSH  R4
                               
                               LOAD  R3  R0
                               LOAD  R2  GB
                                ADD  R2  FORK_DIAG0
                               
                                BRS  encode_grid            ; Returns in R0
                               LOAD  R4  R0
                               
check_forks_while:             LOAD  R1  [R2]               ; Load fork from RAM in R1
                                
                                CMP  R1  -1                 ; Forks are -1 terminated
                                BEQ  check_forks_r
                                
                               LOAD  R0  R4
                                AND  R0  R1                 ; Compare fork with current state
                                CMP  R0  R1
                                BEQ  check_forks_found
                                
                                ADD  R2  3                  
                                BRA  check_forks_while
                   
check_forks_found:              DIV  R3  2
                                ADD  R3  1
                                MOD  R3  2
                                ADD  R3  1
                                
                               LOAD  R0  [R2+R3]
                                BRS  do_move
                               LOAD  R0  -1
                                
                   
check_forks_r:                  PULL  R4
                                PULL  R3
                                PULL  R2
                                PULL  R1
                                 RTS
;---------------------------------------------------------------------------------;		                                
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.	 
check_center:                  LOAD  R0  GB
                                ADD  R0  GRID
                               LOAD  R0  [R0+4]         ; Load center value in R0
                               
                                CMP  R0  1
                                BNE  check_center_r
               
                               LOAD  R0  4
                                BRS  do_move
                               LOAD  R0  -1
               
check_center_r:                 RTS
;---------------------------------------------------------------------------------;		                                
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.
check_opposite_corners:        PUSH  R1
                               PUSH  R2
                               
                               LOAD  R0  GB
                                ADD  R0  GRID
                                
                               LOAD  R2  0
                               LOAD  R1  [R0+R2]
                                CMP  R1  0
                                BNE  check_opposite_corner_1
                             
                               LOAD  R2  8
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_opposite_corner_found
                             
check_opposite_corner_1:       LOAD  R2  2
                               LOAD  R1  [R0+R2]
                                CMP  R1  0
                                BNE  check_opposite_corner_2
                             
                               LOAD  R2  6
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_opposite_corner_found
                               
check_opposite_corner_2:       LOAD  R2  6
                               LOAD  R1  [R0+R2]
                                CMP  R1  0
                                BNE  check_opposite_corner_3
                             
                               LOAD  R2  2
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_opposite_corner_found
                                
check_opposite_corner_3:       LOAD  R2  8
                               LOAD  R1  [R0+R2]
                                CMP  R1  0
                                BNE  check_opposite_corner_r
                             
                               LOAD  R2  0
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BNE  check_opposite_corner_r
                                
check_opposite_corner_found:   LOAD  R0  R2
                                BRS  do_move
                               LOAD  R0  -1

check_opposite_corner_r:      PULL  R2
                               PULL  R1
                                RTS
;---------------------------------------------------------------------------------;		                                
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.
check_empty_corner:            PUSH  R1
                               PUSH  R2
                               
                               LOAD  R2  0
                               LOAD  R0  GB
                                ADD  R0  GRID
                                
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_empty_corner_found
                             
                               LOAD  R2  2
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_empty_corner_found
                               
                               LOAD  R2  6                               
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_empty_corner_found
                               
                               LOAD  R2  8
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BNE  check_empty_corner_r
                                
check_empty_corner_found:      LOAD  R0  R2
                                BRS  do_move
                               LOAD  R0  -1

check_empty_corner_r:          PULL  R2
                               PULL  R1
                                RTS
;---------------------------------------------------------------------------------;                                
; OUTPUT: R0 = -1 if and only if it has found (and done) a move.
check_empty_side:              PUSH  R1
                               PUSH  R2
                               
                               LOAD  R2  1
                               LOAD  R0  GB
                                ADD  R0  GRID
                                
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_empty_corner_found
                             
                               LOAD  R2  3
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_empty_corner_found
                               
                               LOAD  R2  5                               
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BEQ  check_empty_corner_found
                               
                               LOAD  R2  7
                               LOAD  R1  [R0+R2]
                                CMP  R1  1
                                BNE  check_empty_corner_r
                                
check_empty_side_found:        LOAD  R0  R2
                                BRS  do_move
                               LOAD  R0  -1

check_empty_side_r:            PULL  R2
                               PULL  R1
                                RTS                                
;---------------------------------------------------------------------------------;		                                
; INPUT: R0 containing the index of the move to make.                                
do_move:                       PUSH  R2
                               PUSH  R1
                               PUSH  R0
                               
                               LOAD  R2  R0
                                MOD  R0  3
                                DIV  R2  3
                               LOAD  R1  R2
                                BRS  move_to_pos
                                BRS  place_disk
                               
                               LOAD  R0  5000                   ; Check whether the disk was placed correctly.
                                BRS  sleep_i
                                BRS  essential_routines
                               LOAD  R0  [GB+SCANNEDCOLOR]
                                CMP  R0  2
                                BEQ  do_move_r
                              
                                BRS  place_disk                 ; try again
                               
                               LOAD  R0  5000                   ; Check whether the disk was placed correctly.
                                BRS  sleep_i
                                BRS  essential_routines
                               LOAD  R0  [GB+SCANNEDCOLOR]
                                CMP  R0  2
                                BEQ  do_move_r
                               
                               LOAD  R0  ' 3'
                                BRA  error_state

do_move_r:                     PULL  R0
                               
                               LOAD  R1  GB
                                ADD  R1  GRID
                               
                               LOAD  R2  2
                               STOR  R2  [R1+R0]
                               
                               PULL  R1
                               PULL  R2
                                RTS
;---------------------------------------------------------------------------------;		                                
;INPUT: R0 = wanted color
;OUTPUT R0 = current grid encoded in one word, aka 18 bits.
encode_grid:                                                ; R0 = result
                               PUSH  R1                     ; R1 = for counter
                               PUSH  R2                     ; R2 = copy of input
                               PUSH  R3                     ; R3 = color currently in grid.
                               
                               LOAD  R1  0                  ; for counter = 0
                               
                               LOAD  R2  GB                 ; Use R2 to push the grid pointer to the stack.
                                ADD  R2  GRID
                               PUSH  R2
                               
                               LOAD  R2  R0                 ; copy input into R2 so we can use R0 as output.
                               LOAD  R0  0
                               
encode_grid_for:               LOAD  R3  [[SP]+R1]          ; Load color present in the grid in R3
                               
                                CMP  R3  1                  ; Color is background, so we can just add it to the result.
                                BEQ  encode_grid_for_add
                                
                                CMP  R3  R2                 ; Color is equal to wanted color, so encode to 11.
                                BEQ  encode_grid_for_11
                                
                               LOAD  R3  %010                ; Color is not equal to wanted, ie unwanted, so encode to 10.
                                BRA  encode_grid_for_add

encode_grid_for_11:            LOAD  R3  %011 
                
encode_grid_for_add:             OR  R0  R3

                                CMP  R1  8                  ; If this is the last iteration, do not multiple, else do.
                                BEQ  encode_grid_for_skip
                               
                               MULS  R0  %0100
                                
encode_grid_for_skip:           ADD  R1  1                  ; increment for counter by 1.
                                CMP  R1  8                  
                                BLE  encode_grid_for
                               
                                ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS
;---------------------------------------------------------------------------------;		                                                                
store_prev_grid:               PUSH  R0             ; grid pointer
                               PUSH  R1             ; counter
                               PUSH  R2
                               
                               LOAD  R1  0
                               LOAD  R0  GB
                                ADD  R0  GRID
                                
store_prev_grid_for:           LOAD  R2  [R0]
                               STOR  R2  [R0+10]

                                ADD  R0  1
                                ADD  R1  1
                                
                                CMP  R1  10
                                BLT  store_prev_grid_for
                               
                               PULL  R2
                               PULL  R1
                               PULL  R0
                                RTS
;---------------------------------------------------------------------------------;
@END