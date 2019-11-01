
;*=$0801
;        byte $0c,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00,$00
*=$0810
;        jmp   Start
;

;*=$1000
;Start
FRAME_COUNT = #3

frame_counter = $DD00

frame_counter2 = FRAME_COUNT
loop    
        lda FRAME_COUNT
        sta frame_counter
        ldx frame_counter
        jmp loop