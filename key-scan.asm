*=$0801
        ;jmp new
        byte $0c,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00,$00
*=$0810



PRINTCNT = $1009
TERM_START = $0772

RESULT = $1007
RESULTP = $100A ; previous result

        ; debug
        ;lda #$ff
        ;sta PRB
        ; debug

        lda #$00
        sta PRINTCNT
        sta RESULT
mainloop
        jsr checkkeys
        lda RESULT
        cmp RESULTP
        beq mainloop
        jsr newresult
        ; check if result changed from what it was last time
        
        jmp mainloop

newresult
        sta RESULTP
        ldx RESULT
        lda KEYMAP,x
        ; if it's zero ignore the key
        cmp #$00
        beq eend
        ; if it's backspace dec print pointer
        cmp #$fe ; return char
        beq return
        cmp #$ff
        bne printchar
        dec PRINTCNT    ; delete previous
        lda #$20
        ldx PRINTCNT
        sta TERM_START,x      
        rts
return
        ; return pointer
        lda #$00
        sta PRINTCNT
        ; clear line
        ldx #$40 ; cols
        lda #$20 ; space
clrlne  sta TERM_START,x
        dex
        bne clrlne
        sta TERM_START,x ; clear the zero pos
        rts
printchar
        ldx PRINTCNT
        sta TERM_START,x
        inc PRINTCNT
eend    rts


PRA  =  $dc00            ; CIA#1 (Port Register A)
DDRA =  $dc02            ; CIA#1 (Data Direction Register A)
PRB  =  $dc01            ; CIA#1 (Port Register B)
DDRB =  $dc03            ; CIA#1 (Data Direction Register B)

HITCOUNT = $1008

checkkeys    
        sei             ; interrupts deactivated
        lda #%11111111  ; CIA#1 port A = outputs 
        sta DDRA             
        lda #%00000000  ; CIA#1 port B = inputs
        sta DDRB             
new
        ldy #%11111110
        sty $1001
        lda #$00        ; counter which one was hit
        sta HITCOUNT
outer
        lda $1001
        sta PRA

st      ldy #%00000001
        sty $1000
loop     
        lda PRB
        and $1000
        beq match
        inc HITCOUNT 
        asl $1000
        beq nextouter
        jmp loop
nextouter
        sec             ; set carry to we get a 1 in the LSB
        ROL $1001
        lda $1001
        cmp #%11111111
        ;beq new this will loop until a key is pressed
        bne outer
        ; return back to mainloop
        lda #$03  ; didn't find key down, could move to short circuit
        sta RESULT
        jmp donesbr
match
        lda HITCOUNT
        sta RESULT
donesbr 
        cli
        rts

KEYMAP
        ; key map
        ; using bit #3 as a no key
        byte $ff,$fe,$00,$00,$00,$00,$00,$00   ; ff, fe are delete and return
        byte $33,$17,$01,$34,$1a,$13,$05,$00
        byte $35,$12,$04,$36,$03,$06,$14,$18
        byte $37,$19,$07,$38,$02,$08,$15,$16
        byte $39,$09,$0a,$30,$0d,$0b,$0f,$0e
        byte $2b,$10,$0c,$2d,$2e,$3a,$00,$00
        byte $1c,$2a,$3b,$00,$00,$3d,$1e,$00
        byte $31,$1f,$00,$32,$20,$00,$11,$00