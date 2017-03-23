@CODE
;---------------------------------------------------------------------------------;		
;INPUT: R0 color to check
check_win:                    PUSH  R1

                              ; Check rows
                              LOAD  R1  R0
                              LOAD  R0  0
                               BRS  check_win_row
                               CMP  R0  1
                               BEQ  do_win
                               
                              LOAD  R0  1
                               BRS  check_win_row
                               CMP  R0  1
                               BEQ  do_win
                               
                              LOAD  R0  2
                               BRS  check_win_row
                               CMP  R0  1
                               BEQ  do_win
                               
                              ; Check cols
                              LOAD  R0  0
                               BRS  check_win_col
                               CMP  R0  1
                               BEQ  do_win
                               
                              LOAD  R0  1
                               BRS  check_win_col
                               CMP  R0  1
                               BEQ  do_win
                               
                              LOAD  R0  2
                               BRS  check_win_col
                               CMP  R0  1
                               BEQ  do_win
                               
                               ; Check diagnals
                               BRS  check_win_diag1
                               CMP  R0  1
                               BEQ  do_win
                               
                               BRS  check_win_diag2
                               CMP  R0  1
                               BEQ  do_win
                
check_win_r:                  PULL  R1
                               RTS 
;---------------------------------------------------------------------------------;
;INPUT: R1 color who has won.
do_win:                        CMP  R1  2
                               BEQ  machine_win
                               CMP  R1  0
                               BEQ  player_win
                                
                               BRA  check_win_r     ; do_win only gets called from check_win via conditional branch...                               
;---------------------------------------------------------------------------------;		
; INPUT: R0 = y
;        R1 = color
; OUTPUT: R0 = 1 if color has won.
check_win_row:                 PUSH  R1
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
                                BNE  check_win_row_check_empty1
                                ADD  R3  1
                                BRA  check_win_row_color2
                                
check_win_row_check_empty1:     CMP  R0  1
                                BNE  check_win_row_color2
                                ADD  R4  1
                                
check_win_row_color2:           ADD  R2  1
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_win_row_check_empty2
                                ADD  R3  1
                                BRA  check_win_row_color3
                                
check_win_row_check_empty2:     CMP  R0  1
                                BNE  check_win_row_color3
                                ADD  R4  1                                 
                                
check_win_row_color3:           ADD  R2  1
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_win_row_check_empty3
                                ADD  R3  1
                                BRA  check_win_row_count_colors
                                
check_win_row_check_empty3:     CMP  R0  1
                                BNE  check_win_row_count_colors
                                ADD  R4  1                                    

                              
check_win_row_count_colors:    LOAD  R0  0     
                                CMP  R3  3
                                BNE  check_win_row_r
                               LOAD  R0  1
                                
check_win_row_r:                ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS
;---------------------------------------------------------------------------------;		                                
; INPUT: R0 = x
;        R1 = color
; OUTPUT: R0 = 1 if the color has won.
check_win_col:                 PUSH  R1
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
                                BNE  check_win_col_check_empty1
                                ADD  R3  1
                                BRA  check_win_col_color2
                                
check_win_col_check_empty1:     CMP  R0  1
                                BNE  check_win_col_color2
                                ADD  R4  1
                                
check_win_col_color2:           ADD  R2  3
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_win_col_check_empty2
                                ADD  R3  1
                                BRA  check_win_col_color3
                                
check_win_col_check_empty2:     CMP  R0  1
                                BNE  check_win_col_color3
                                ADD  R4  1                                 
                                
check_win_col_color3:           ADD  R2  3
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_win_col_check_empty3
                                ADD  R3  1
                                BRA  check_win_col_count_colors
                                
check_win_col_check_empty3:     CMP  R0  1
                                BNE  check_win_col_count_colors
                                ADD  R4  1                                    

                              
check_win_col_count_colors:    LOAD  R0  0      
                                CMP  R3  3
                                BNE  check_win_col_r
                               LOAD  R0  1
                                
check_win_col_r:                ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS

;---------------------------------------------------------------------------------;		                                
; INPUT:  R1 = color
; OUTPUT: R0 = 1 if the color has won.
check_win_diag1:               PUSH  R1
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
                                BNE  check_win_diag1_check_empty1
                                ADD  R3  1
                                BRA  check_win_diag1_color2
                                
check_win_diag1_check_empty1:  CMP  R0  1
                                BNE  check_win_diag1_color2
                                ADD  R4  1
                                
check_win_diag1_color2:        ADD  R2  4
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_win_diag1_check_empty2
                                ADD  R3  1
                                BRA  check_win_diag1_color3
                                
check_win_diag1_check_empty2:  CMP  R0  1
                                BNE  check_win_diag1_color3
                                ADD  R4  1                                 
                                
check_win_diag1_color3:        ADD  R2  4
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_win_diag1_check_empty3
                                ADD  R3  1
                                BRA  check_win_diag1_count_colors
                                
check_win_diag1_check_empty3:  CMP  R0  1
                                BNE  check_win_diag1_count_colors
                                ADD  R4  1                                    

                              
check_win_diag1_count_colors: LOAD  R0  0         
                                CMP  R3  3
                                BNE  check_win_diag1_r
                               LOAD  R0  1
                                
check_win_diag1_r:             ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS
;---------------------------------------------------------------------------------;		                                
; INPUT:  R1 = color
; OUTPUT: R0 = 1 if the color wins.
check_win_diag2:               PUSH  R1
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
                                BNE  check_win_diag2_check_empty1
                                ADD  R3  1
                                BRA  check_win_diag2_color2
                                
check_win_diag2_check_empty1:   CMP  R0  1
                                BNE  check_win_diag2_color2
                                ADD  R4  1
                                
check_win_diag2_color2:         ADD  R2  2
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_win_diag2_check_empty2
                                ADD  R3  1
                                BRA  check_win_diag2_color3
                                
check_win_diag2_check_empty2:   CMP  R0  1
                                BNE  check_win_diag2_color3
                                ADD  R4  1                                 
                                
check_win_diag2_color3:         ADD  R2  2
                               LOAD  R0  [[SP]+R2]
                                
                                CMP  R0  R1     
                                BNE  check_win_diag2_check_empty3
                                ADD  R3  1
                                BRA  check_win_diag2_count_colors
                                
check_win_diag2_check_empty3:   CMP  R0  1
                                BNE  check_win_diag2_count_colors
                                ADD  R4  1                                    

                              
check_win_diag2_count_colors:  LOAD  R0  0       
                                CMP  R3  3
                                BNE  check_win_diag2_r
                               LOAD  R0  1
                                
check_win_diag2_r:              ADD  SP  1
                               PULL  R3
                               PULL  R2
                               PULL  R1
                                RTS                   
;---------------------------------------------------------------------------------;
machine_win:                  LOAD  R0  -1
                              STOR  R0  [GB+DSP_DEC]
                              LOAD  R0  3
                              LOAD  R1  2
                               BRS  move_to_pos

machine_win_while:             BRS  update_display
                              LOAD  R0  ' y'
                              STOR  R0  [GB+DSP_ASCII]
                              LOAD  R0  'ou'
                              STOR  R0  [GB+DSP_ASCII_1]
                              LOAD  R0  '  '
                              STOR  R0  [GB+DSP_ASCII_2]
                              LOAD  R0  10000
                               BRS  sleep_i
                              
                              LOAD  R0  ' l'
                              STOR  R0  [GB+DSP_ASCII]
                              LOAD  R0  'os'
                              STOR  R0  [GB+DSP_ASCII_1]
                              LOAD  R0  'e '
                              STOR  R0  [GB+DSP_ASCII_2]
                              LOAD  R0  10000
                               BRS  sleep_i
                               
                               BRS  poll_inputs
                              LOAD  R0  [GB+INPUTSTATE]
                               AND  R0  %010
                               CMP  R0  %010
                               BNE  machine_win_while
                               BRA  reset
;---------------------------------------------------------------------------------;                        
player_win:                   LOAD  R0  -1
                              STOR  R0  [GB+DSP_DEC]
                              LOAD  R0  3
                              LOAD  R1  2
                               BRS  move_to_pos

player_win_while:              BRS  update_display
                              LOAD  R0  'i '
                              STOR  R0  [GB+DSP_ASCII]
                              LOAD  R0  'lo'
                              STOR  R0  [GB+DSP_ASCII_1]
                              LOAD  R0  'se'
                              STOR  R0  [GB+DSP_ASCII_2]
                               
                               BRS  poll_inputs
                              LOAD  R0  [GB+INPUTSTATE]
                               AND  R0  %010
                               CMP  R0  %010
                               BNE  machine_win_while
                               BRA  reset
;---------------------------------------------------------------------------------;     
tie:                          LOAD  R0  -1
                              STOR  R0  [GB+DSP_DEC]
                              LOAD  R0  3
                              LOAD  R1  2
                               BRS  move_to_pos       
                               
tie_while:                     BRS  update_display
                              LOAD  R0  ' t'
                              STOR  R0  [GB+DSP_ASCII]
                              LOAD  R0  'ie'
                              STOR  R0  [GB+DSP_ASCII_1]
                              LOAD  R0  'd '
                              STOR  R0  [GB+DSP_ASCII_2]
                               
                               BRS  poll_inputs
                              LOAD  R0  [GB+INPUTSTATE]
                               AND  R0  %010
                               CMP  R0  %010
                               BNE  tie_while
                               BRA  reset           
@END