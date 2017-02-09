@DATA
BOOLEAN         DW 0
PREV_BTNS       DW 0
@CODE

   IOAREA      EQU  -16  ;  address of the I/O-Area, modulo 2^18
    INPUT      EQU    7  ;  position of the input buttons (relative to IOAREA)
   OUTPUT      EQU   11  ;  relative position of the power outputs
   DSPDIG      EQU    9  ;  relative position of the 7-segment display's digit selector
   DSPSEG      EQU    8  ;  relative position of the 7-segment display's segments
   TIMER       EQU   13
   ADCONVS     EQU    6  ;  relative position of the A/D converters.

begin :          BRA  main         ;  skip subroutine Hex7Seg
;  
;      Routine Hex7Seg maps a number in the range [0..15] to its hexadecimal
;      representation pattern for the 7-segment display.
;      R0 : upon entry, contains the number
;      R1 : upon exit,  contains the resulting pattern
;
Hex7Seg     :    BRS  Hex7Seg_bgn  ;  push address(tbl) onto stack and proceed at "bgn"
Hex7Seg_tbl :   CONS  %01111110    ;  7-segment pattern for '0'
                CONS  %00110000    ;  7-segment pattern for '1'
                CONS  %01101101    ;  7-segment pattern for '2'
                CONS  %01111001    ;  7-segment pattern for '3'
                CONS  %00110011    ;  7-segment pattern for '4'
                CONS  %01011011    ;  7-segment pattern for '5'
                CONS  %01011111    ;  7-segment pattern for '6'
                CONS  %01110000    ;  7-segment pattern for '7'
                CONS  %01111111    ;  7-segment pattern for '8'
                CONS  %01111011    ;  7-segment pattern for '9'
                CONS  %01110111    ;  7-segment pattern for 'A'
                CONS  %00011111    ;  7-segment pattern for 'b'
                CONS  %01001110    ;  7-segment pattern for 'C'
                CONS  %00111101    ;  7-segment pattern for 'd'
                CONS  %01001111    ;  7-segment pattern for 'E'
                CONS  %01000111    ;  7-segment pattern for 'F'
Hex7Seg_bgn:     AND  R0  %01111   ;  R0 := R0 MOD 16 , just to be safe...
                LOAD  R1  [SP++]   ;  R1 := address(tbl) (retrieve from stack)
                LOAD  R1  [R1+R0]  ;  R1 := tbl[R0]
                 RTS
;
main:           LOAD  R5 IOAREA                 ; R5 will store the start of the IOAREA.
                LOAD  R0 %010000000
                STOR  R0 [R5+OUTPUT]
                LOAD  R4 0                      ; R4 will keep track of which display to update.
                LOAD  R3 [R5 + TIMER]           ; R3 = x
;
loop:           LOAD  R0 [R5 + ADCONVS]         ; Load R0 with the current state of the knob.
                 AND  R0 %011111111      ; We're only interested in the last 8 bits, so put the other values to 0.
                 CMP  R0 70
                 BGE  loop_1
                LOAD  R0 0
                 BRA  loop_2
loop_1:         LOAD  R0 30
                ;MULS  R0 100
                 ;DIV  R0 255                    ; R0 = n
loop_2:         LOAD  R2 [R5 + TIMER]           ; R2 = y
                 SUB  R2 R3
                MULS  R2 -1
                 BRS  set_led
                 BRS  check_x
                 BRS  update_dsp                ; Update the display, and return back here afterwards.
                 BRS  check_btns
                
                 BRA  loop                      ; Loop back to the start of the loop.
;
set_led:           LOAD  R1 [GB+BOOLEAN]
                    CMP  R2 R0                   
                    BPL led_off
led_on:             CMP  R1 0
                    BEQ  led_on_left
                   LOAD  R1 %001
                    BRA  store_led
led_on_left:       LOAD  R1 %010
                    BRA  store_led
led_off:           LOAD  R1 %000                    
                    BRA  store_led
store_led:           OR   R1 %010000000
                    STOR  R1 [R5 + OUTPUT]
                     RTS                     
toggle_r1:           XOR  R1 %010
                     RTS
check_x:             CMP  R2 100
                     BPL  update_x                       ; if > 0 then:
                     RTS
update_x:           LOAD  R3 [R5 + TIMER]
                     SUB  R2 100
                     SUB  R3 R2
                     RTS
update_dsp:         LOAD  R1 R4                 ; Copy R4, which holds the display to update, into R1 so it can be modified.
                     ADD  R4 1                  ; Increment R4 by 1, so the next display can be updated later.
                     DIV  R1 100                ; We want to update the next display every 100 ticks.
                     CMP  R1 0                  ; If R1 == 0
                     BEQ  update_dsp_0          ;   then update display 0.
                     CMP  R1 1                  ; else if R1 == 1
                     BEQ  update_dsp_1          ;   then update display 1.
                     CMP  R1 2                  ; else if R1 == 2
                     BEQ  update_dsp_2          ;   then update display 2.
                    LOAD  R4 0                  ; else reset R4.
                     RTS                        ; return
update_dsp_0:        MOD  R0 10                 ; R0 % 10 will return the right digit to display.
                     BRS  Hex7Seg               ; Convert R0 into a segment and load in R1.
                    STOR  R1 [R5+DSPSEG]        ; Set the display segment we just calculated.
                    LOAD  R1 %000001            ; Update the right display.
                    STOR  R1 [R5+DSPDIG]        ; Update the right display.
                     RTS                        ; return
update_dsp_1:        MOD  R0 100                ; R0 % 100 will return the last two digits.
                     DIV  R0 10                 ; Dividing it by 10 will return the middle digit.
                     BRS  Hex7Seg               ; Convert R0 into a segment and load in R1.
                    STOR  R1 [R5+DSPSEG]        ; Set the display segment we just calculated.
                    LOAD  R1 %000010            ; Update the middle display.
                    STOR  R1 [R5+DSPDIG]        ; Update the middle display.
                     RTS                        ; return 
update_dsp_2:        DIV  R0 100                ; R0 / 100 will return the left digit.
                     BRS  Hex7Seg               ; Convert R0 into a segment and load in R1.
                    STOR  R1 [R5+DSPSEG]        ; Set the display segment we just calculated.
                    LOAD  R1 %000100            ; Update the left display.
                    STOR  R1 [R5+DSPDIG]        ; Update the left display.
                     RTS                        ; return          
check_btns:         LOAD  R1 [R5+INPUT]
                    LOAD  R0 [GB+PREV_BTNS]
                    STOR  R1 [GB+PREV_BTNS]
                     CMP  R0 0
                     BNE  return
                     CMP  R1 %00000001
                     BEQ  btn_0_press
                     RTS
btn_0_press:        LOAD  R0 [GB+BOOLEAN]
                     XOR  R0 1
                    STOR  R0 [GB+BOOLEAN]
return:              RTS                
@END
