*=$0801
        byte $0c,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00,$00
*=$0810
        jmp   Start

FRAME_COUNT = #3 ; load the value 3 into 
frame_counter = $DD00
STARTM = $0002

;*=$1000
Start
        ldx #$00
        stx $d021    ; set background color
        stx $d020    ; set border color

        tax
        lda #$20        ; space
loop    sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        dex
        bne loop  ; end clear screen

        ; Printing a 0-terminated string of up to 256 byte length to screen

        LDX #$0F    ; Select row
        LDY #$0a    ; Select column
        JSR $E50C   ; Set cursor
         
        LDA #<STRING  ; Load lo-byte of string adress
        LDY #>STRING  ; Load hi-byte of string adress
        JSR $AB1E     ; Print string

        ;jsr $E8EA
        LDX #$10    ; Select row
        LDY #$0a    ; Select column
        JSR $E50C   ; Set cursor
        LDA #<STRING2  ; Load lo-byte of string adress
        LDY #>STRING2  ; Load hi-byte of string adress
        JSR $AB1E     ; Print string
        ;RTS           ; End.
mainloop        
        sta $0400
        jsr $FFE4  ;get key
        ;cmp achar
        beq mainloop
        jsr $E8EA
        beq mainloop
        ; read key
        ;jmp mainloop
        ;sta $0400
        rts

 
STRING  text "hello"
        byte $00 

STRING2 text "world"
        byte $00 


achar
        byte 'A'

        ldx #$0F ;'#$008f-$0002 ; zero in x
clear   lda #$99
        sta STARTM,x
        dex
        bne clear
        ldx #$04
        stx $d021    ; set background color
        stx $d020    ; set border color
        rts
;loop    
;        lda FRAME_COUNT
;        ldx test
;        sta frame_counter
;        ldx frame_counter
;        jmp loop