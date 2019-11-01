*=$0801
       ; jmp start
        byte $0c,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00,$00
*=$0810


;CHKIN = $FFC6  
;CHRIN = $FFCF
;GETIN = $FFE4   

;DATA = $1000

;CURSORX = #$00
;CURSORY = #$00

PRA  =  $dc00            ; CIA#1 (Port Register A)
DDRA =  $dc02            ; CIA#1 (Data Direction Register A)

PRB  =  $dc01            ; CIA#1 (Port Register B)
DDRB =  $dc03            ; CIA#1 (Data Direction Register B)

;Store a typed string to the screen.
        
start
        LDY #$00

        ; paint cursor
        lda #160
        sta $07C0
WAIT   
        JSR CHRIN  ; get key
        CMP #$0D
        BEQ Done

        SEC 
        sbc #64   ; subtract 40
        sta $0400,y
        iny
        JMP WAIT
Done
        ; clear entry field
        ;lda #$00
        ;sta $0F
        
        ;LDX #$19    ; Select row
       ; LDY #$00    ; Select column
        ;JSR $E50C   ; Set cursor
        jmp start
