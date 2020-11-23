.include "./m328Pdef.inc" ; directive for pin and register definitions

.EQU    SEG_ONE = 0x7B ; 0x7B = 0b01111011
.EQU    SEG_TWO = 0x34 ; 0x34 = 0b00110100
.EQU    SEG_THREE = 0x31 ; 0x31 = 0b00110001
.EQU    SEG_FOUR = 0x63 ; 0x63 = 0b01100011
.EQU    SEG_FIVE = 0x81 ; 0x81 = 0b10000001
.EQU    SEG_SIX = 0x80 ; 0x80 = 0b10000000

init:
    ldi     r16, 0xFF ; set PORTD as output where is 7seg display
    out     DDRD, r16
    ldi     r16, 0xFF
    out     PORTD, r16 ; pull all PORTD internally to logical 1, so turn off LED
        
    ldi     r16, 0b11111000 ; set PC0, PC1, PC2 as input and rest of pins as
                            ; output
    out     DDRC, r16
    ldi     r16, 0xFF
    out     PORTC, r16 ; pull all PORTC internally to logical 1
main:
    in      r16, PINC ; read the value from PORTC
    andi    r16, 0x07 ; 0x07 = 0b00000111 this will keep only MSB: PC0, PC1, PC2
    cpi     r16, 0x05 ; 0x05 = 0b11111101 compare R16 with 0x05. If PC1 = GND,
                      ; then jump to SW0 label
    breq    increaseNumb
    rjmp    main
                  
startCount:    
    call    increaseNumb
    call    decreaseNumb
    rjmp    main
    
delay:    
    ldi     r16, 50
    ldi     r18, 18
    loop_2:
        ldi     R17, 17
    loop_1:   
        dec     R18
        brne    loop_1
        dec     R17 ; dec decrements 8bit register. DEC instruction sets Z flag
                    ; in the status register 
        brne    loop_1 ; branch if not equal. Tests if the result of the 
                       ; previous operation was zero. If it was not, brne jump 
                       ; to the label given as an operand. If it was zero 
                       ; brne will continue to the next instruction.
        dec     R16
        brne    loop_2
    ret  
    
decreaseNumb:
    call    delay
    ldi     r16, SEG_SIX
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_FIVE
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_FOUR
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_THREE
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_TWO
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_ONE
    out     PORTD, r16
    call    delay
    rjmp    decreaseNumb
         
increaseNumb:
    call    delay
    ldi     r16, SEG_ONE
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_TWO
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_THREE
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_FOUR
    out     PORTD, r16
    call    delay
    ldi     r16, SEG_FIVE
    out     PORTD, r16
    call    delay
    
    ldi     r16, SEG_SIX
    out     PORTD, r16 
    call    delay
    
    andi    r20, 0x00
    in      r16, PINC
    andi    r16, 0x07
    cpi     r16, 0x06 ; 0b11111110 PC0
    breq    increaseAgainFlag     
    rjmp    increaseNumb 

increaseAgainFlag:
    inc     R20
    cpi     r20, 0x01
    breq    decreaseNumb
ret
    
    
    
    
    
    
    
    
    
    
    
