*=$0801
       ;jmp clearbottom
        byte $0c,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00,$00
*=$0810


CHKIN = $FFC6  
CHRIN = $FFCF
GETIN = $FFE4   

DATA = $1000

CURSORX = #$00
CURSORY = #$00


;clear screen
        lda #$20        ; space
loop    sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        dex
        bne loop  ; end clear screen

start
        LDY #$00
        LDX #$18    ; Select row
        LDY #$00    ; Select column
        JSR $E50C   ; Set cursor
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
        jsr clearbottom
        jmp start

;clear bottom line
clearbottom
        lda #$20
        ldx #40 ; cols
clearloop
        sta $07C0,x
        dex
        bne clearloop
        sta $07C0,x
        rts
