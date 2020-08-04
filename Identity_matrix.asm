; --------------IDENTITY MATRIX----------------
; THIS PROGRAM GET A ONE DIGIT NUMBER FROM USER AND MAKE A N * N IDENTITY MATRIX.
.MODEL SMALL
.DATA
    INPUT DB ?       ; CONTAIN INPUT NUMBER
    COUNTER DB 00H   ; USING FOR PRINT 1's
    ROW_COUNTER DB 00H ; COUNT THE NUMBER OF ROWS PRINTED SO FAR.
    MSG1 DB "ENTER THE MATRIX SIZE (ONLY ONE NUMBER): $"
    NEW_LINE DB 0DH,0AH, '$'  ; NEW LINE CODE.
    ONE DB "1    $"
    ZERO DB "0    $"

.CODE   
MAIN PROC
        
    MOV AX, @DATA
    MOV DS, AX ; INITIALIZATION OF DATA SEGMENT.
        
    LEA DX, MSG1 ; PRINT MSG1 TO STANDARD OUTPUT.
    MOV AH, 9
    INT 21H
        
    MOV AH, 1 ; READ THE INPUT.
    INT 21H
    
    SUB AL, 30H ; CONVERT ASCII TO DECIMAL.
    MOV INPUT, AL ; STORE INPUT VALUE.
    
    LEA DX, NEW_LINE ; \n
    MOV AH, 9
    INT 21H
    
    XOR AX, AX ; ASSIGN 0 TO ALL REGISTERS.
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    
    MOV CL, INPUT
    ALL:
        CALL PRINT_ROW
        
        LEA DX, NEW_LINE ; \n
        MOV AH, 9
        INT 21H
        
        MOV CL, INPUT
        SUB CL, ROW_COUNTER
        INC ROW_COUNTER
         
        LOOP ALL
    
    MOV AX, 4C00H
    INT 21H
MAIN ENDP

PRINT_ROW PROC
    MOV CL, INPUT
    MOV COUNTER, 00H
    ROW: 
        MOV BL, ROW_COUNTER ; COMPARE ROW_CONTER WITH COUNTER.
        CMP BL, COUNTER
    
        JNE CON1
        CALL PRINT_ONE ; GO PRINT THE 1's.
        DEC CL ; MANUALLY DECREMENT CL
        CMP CL, 00H
        JE CON2
        CON1:
        CALL PRINT_ZERO ; GO PRINT THE 0's.
        LOOP ROW
        CON2:
        RET
PRINT_ROW ENDP
        
PRINT_ONE PROC
    LEA DX, ONE ; PRINT "1    "
    MOV AH, 9
    INT 21H
        
    INC COUNTER
        
    RET
PRINT_ONE ENDP

PRINT_ZERO PROC
    LEA DX, ZERO ; PRINT "0    "
    MOV AH, 9
    INT 21H
    
    INC COUNTER
        
    RET
PRINT_ZERO ENDP

END MAIN