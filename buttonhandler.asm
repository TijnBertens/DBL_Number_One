@CODE
   
handle_btns: PUSH  R0
             PUSH  R1
             PUSH  R2
             PUSH  R3
             PUSH  R4

             LOAD  R0  [GB+PREVINPUTSTATE]
             LOAD  R1  [GB+INPUTSTATE]
              CMP  R0  0
              BEQ  r_handle_btns
              CMP  R1  %000000001
              BEQ  btn_press0
              CMP  R1  %000000010
              BEQ  btn_press1
              CMP  R1  %000000100
              BEQ  btn_press2
              CMP  R1  %000001000
              BEQ  btn_press3
              CMP  R1  %000010000
              BEQ  btn_press4
              CMP  R1  %000100000
              BEQ  btn_press5
              CMP  R1  %001000000
              BEQ  btn_press6
              CMP  R1  %010000000
              BEQ  btn_press7
              BRA  r_handle_btns
              
btn_press0:  LOAD  R0  [GB+MOTORDIRECTION0]
              BRS  toggle_dir
             STOR  R0  [GB+MOTORDIRECTION0]
              BRA  r_handle_btns
btn_press1:  LOAD  R0  [GB+MOTORDIRECTION1]
              BRS  toggle_dir
             STOR  R0  [GB+MOTORDIRECTION1]
              BRA  r_handle_btns
btn_press2:  LOAD  R0  [GB+MOTORDIRECTION2]
              BRS  toggle_dir
             STOR  R0  [GB+MOTORDIRECTION2]
              BRA  r_handle_btns
btn_press3:   BRA  r_handle_btns              
btn_press4:   BRA  r_handle_btns              
btn_press5:   BRA  r_handle_btns              
btn_press6:   BRA  r_handle_btns              
btn_press7:   BRA  r_handle_btns              
              
              
toggle_dir:   CMP  R0 0
              BLE  dir_add
             LOAD  R0 -1
              RTS
dir_add:      ADD  R0 1             
              RTS
              
r_handle_btns:
             PULL  R4
             PULL  R3
             PULL  R2
             PULL  R1
             PULL  R0
             
              RTS   
@END              