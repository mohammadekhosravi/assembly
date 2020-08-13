; CALCULATE DETERMINANT OF 3*3 MATRIX.
.MODEL SMALL 
.DATA
    INPUT_ROW DB ?       ; CONTAIN INPUT ROW
    INPUT_COL DB ?       ; CONTAIN INPUT COLUMN
    
    MSG1 DB "ENTER THE MATRIX ELEMENTS: $"
    MSG2 DB "ROW$"
    MSG3 DB " COL$"
    MSG4 DB ": $"
    LINE DB "------------------------------------------------------------- $"
    MSG5 DB "DETERMINANT IS: $" 
    
    NEW_LINE DB 0DH,0AH, '$'  ; NEW LINE CODE.
    
    TO_PRINT DB 20 DUP('$') 
    RESULT LABEL  BYTE
    MAX DB 150
    LEN DB ?
    BUFFER DB 150 DUP('?')
    
    RES LABEL BYTE
    MAX0 DB 150
    LEN0 DB ?
    BUFFER0 DB 150 DUP('?')
    
    FIRST_NUM DB ?
    SECOND_NUM DB ?
    THIRD_NUM DB ?
    FOURTH_NUM DB ?
    MANFI DB 00H
    FIRST_PART DB ?
    FIRST_PART_SIGN DB 00H
    SECOND_PART DB ?
    SECOND_PART_SIGN DB 00H
    THIRD_PART DB ?
    THIRD_PART_SIGN DB 00H
    
        
.CODE   
MAIN PROC

    MOV AX, @DATA
    MOV DS, AX ; INITIALIZATION OF DATA SEGMENT.
        
    LEA DX, MSG1 ; PRINT MSG1 TO STANDARD OUTPUT.
    MOV AH, 9
    INT 21H
     
    MOV INPUT_ROW, 03H ; STORE INPUT VALUE.
    MOV INPUT_COL, 03H ; STORE INPUT VALUE.
    
    ; ----------PRINT NEW LINE--------------------------
    LEA DX, NEW_LINE ; \n
    MOV AH, 9
    INT 21H
    
    ; --------------RESET ALL REGISTERS-----------------
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    
    ; --------------GET INPUTS--------------------------
    CALL INPUT_ELEMENTS
    
    ; CALCULATE DETERMINANT
    CALL THREE_D_DETERMINANT
    
    ; ----------RETURN CONTROL TO OPERATING SYSTEM------
    MOV AX, 4C00H
    INT 21H
    
MAIN ENDP

THREE_D_DETERMINANT PROC
    ; FIRST PART
    MOV SI, 6   
    MOV AL, RES[SI]
    MOV FIRST_NUM, AL; E
    MOV SI, 7
    MOV AL, RES[SI]
    MOV SECOND_NUM, AL; F
    MOV SI, 9
    MOV AL, RES[SI]
    MOV THIRD_NUM, AL; H
    MOV SI, 10
    MOV AL, RES[SI]
    MOV FOURTH_NUM, AL; I
    
    CALL TWO_D_DETERMINANT
    MOV FIRST_PART, AL
    MOV AL, MANFI
    MOV FIRST_PART_SIGN, AL
    
    MOV SI, 2
    MOV AL, RES[SI]
    MOV BL, FIRST_PART
    MUL BL
    MOV FIRST_PART, AL
    
    ; SECOND PART
    MOV SI, 5
    MOV AL, RES[SI]
    MOV FIRST_NUM, AL; D
    MOV SI, 7
    MOV AL, RES[SI]
    MOV SECOND_NUM, AL; F
    MOV SI, 8
    MOV AL, RES[SI]
    MOV THIRD_NUM, AL; G
    MOV SI, 10
    MOV AL, RES[SI]
    MOV FOURTH_NUM, AL; I
    
    CALL TWO_D_DETERMINANT
    MOV SECOND_PART, AL
    MOV AL, MANFI
    MOV SECOND_PART_SIGN, AL
        
    MOV SI, 3
    MOV AL, RES[SI]
    MOV BL, SECOND_PART
    MUL BL
    MOV SECOND_PART, AL
    
    ; THIRD PART
    MOV SI, 5
    MOV AL, RES[SI]
    MOV FIRST_NUM, AL; D
    MOV SI, 6
    MOV AL, RES[SI]
    MOV SECOND_NUM, AL; E
    MOV SI, 8
    MOV AL, RES[SI]
    MOV THIRD_NUM, AL; G
    MOV SI, 9
    MOV AL, RES[SI]
    MOV FOURTH_NUM, AL; H
    
    CALL TWO_D_DETERMINANT
    MOV THIRD_PART, AL
    MOV AL, MANFI
    MOV THIRD_PART_SIGN, AL
        
    MOV SI, 4
    MOV AL, RES[SI]
    MOV BL, THIRD_PART
    MUL BL
    MOV THIRD_PART, AL
    
    ; A - B + C
    MOV AL, FIRST_PART_SIGN
    CMP AL, 00H
    JE P1
    JMP N1
    
    P1:
        MOV AL, THIRD_PART_SIGN
        CMP AL, 00H
        JE P1P2
        JMP P1N2
        
        P1P2:
            MOV AL, FIRST_PART
            ADD AL, THIRD_PART
            MOV FIRST_PART, AL
            MOV FIRST_PART_SIGN, 00H
            JMP CONTINUE
        P1N2:
            MOV AL, FIRST_PART
            CMP AL, THIRD_PART
            JA PS1
            JMP NS1
            
            PS1:
                MOV AL, FIRST_PART
                SUB AL, THIRD_PART
                MOV FIRST_PART, AL
                MOV FIRST_PART_SIGN, 00H
                JMP CONTINUE
            NS1:
                MOV AL, THIRD_PART
                SUB AL, FIRST_PART
                MOV AL, FIRST_PART
                MOV FIRST_PART_SIGN, 01H
                JMP CONTINUE
                
    N1:
        MOV AL, THIRD_PART_SIGN
        CMP AL, 00H
        JE N1P2
        JMP N1N2
        
        N1N2:
            MOV AL, FIRST_PART
            ADD AL, THIRD_PART
            MOV FIRST_PART, AL
            MOV FIRST_PART_SIGN, 01H
            JMP CONTINUE
        N1P2:
            MOV AL, FIRST_PART
            CMP AL, THIRD_PART
            JA NS2
            JMP PS2
            
            PS2:
                MOV AL, THIRD_PART
                SUB AL, FIRST_PART
                MOV FIRST_PART, AL
                MOV FIRST_PART_SIGN, 00H
                JMP CONTINUE
                
           NS2:
               MOV AL, FIRST_PART
               SUB AL, THIRD_PART
               MOV FIRST_PART, AL
               MOV FIRST_PART_SIGN, 01H
               JMP CONTINUE
    
    CONTINUE:
        MOV AL, FIRST_PART_SIGN
        CMP AL, 00H
        JE  POS1
        JMP NEG1
        
        POS1:
            MOV AL, SECOND_PART_SIGN
            CMP AL, 00H
            JE POS1POS2
            JMP POS1NEG2
            
            POS1POS2:
                MOV AL, FIRST_PART
                CMP AL, SECOND_PART
                JA POS1POS2_A
                JMP POS1POS2_B
                
                POS1POS2_A:
                    MOV AL, FIRST_PART
                    SUB AL, SECOND_PART
                    MOV FIRST_PART, AL
                    MOV FIRST_PART_SIGN, 00H
                    JMP END_D
                    
                POS1POS2_B:
                    MOV AL, SECOND_PART
                    SUB AL, FIRST_PART
                    MOV FIRST_PART, AL
                    MOV FIRST_PART_SIGN, 01H
                    JMP END_D
                    
            POS1NEG2:
                MOV AL, FIRST_PART
                ADD AL, SECOND_PART
                MOV FIRST_PART, AL
                MOV FIRST_PART_SIGN, 00H
                JMP END_D
                
        NEG1:
            MOV AL, SECOND_PART_SIGN
            CMP AL, 00H
            JE NEG1POS2
            JMP NEG1NEG2
            
            NEG1POS2:
                MOV AL, FIRST_PART
                ADD AL, SECOND_PART
                MOV FIRST_PART, AL
                MOV FIRST_PART_SIGN, 01H
                JMP END_D
                
            NEG1NEG2:
                MOV AL, SECOND_PART
                CMP AL, FIRST_PART
                JA NEG1NEG2_A
                JMP NEG1NEG2_B
                
                NEG1NEG2_A:
                    MOV AL, SECOND_PART
                    SUB AL, FIRST_PART
                    MOV FIRST_PART, AL
                    MOV FIRST_PART_SIGN, 00H
                    JMP END_D
                    
                NEG1NEG2_B:
                    MOV AL, FIRST_PART
                    SUB AL, SECOND_PART
                    MOV FIRST_PART, AL
                    MOV FIRST_PART_SIGN, 01H
                    JMP END_D
            
                
                        
            
    END_D:
        LEA DX, NEW_LINE
        MOV AH, 9
        INT 21H
        
        LEA DX, NEW_LINE
        MOV AH, 9
        INT 21H
        
        LEA DX, LINE
        MOV AH, 9
        INT 21H
        
        LEA DX, NEW_LINE
        MOV AH, 9
        INT 21H
        
        LEA DX, NEW_LINE
        MOV AH, 9
        INT 21H
        
        LEA DX, MSG5
        MOV AH, 9
        INT 21H
         
        MOV AL, FIRST_PART_SIGN
        CMP AL, 01H
        JE PRINT_MINUS
        JMP PRINT
        
        PRINT_MINUS:
            MOV DL, '-'
            MOV AH, 2
            INT 21H
            
        PRINT:
            LEA SI, TO_PRINT
            XOR AX, AX
            MOV AL, FIRST_PART
            CALL HEX2DEC
            LEA DX, TO_PRINT
            MOV AH, 9
            INT 21H
            
    RET
    
THREE_D_DETERMINANT ENDP

HEX2DEC PROC ; DO THE MATH
    
    XOR CX, CX
    MOV BX, 10

    LOOP1: 
        XOR DX, DX
        DIV BX ; REMINDER IS DL(ACCORDING TO 8086 INSTRUCTION SET)
        ADD DL, 30H ; CONVERT it to ascii
        PUSH DX     ; SAVE it in stack
        INC CX
        CMP AX, 9
        JG LOOP1
        ADD AL, 30H
        MOV [SI], AL

    LOOP2: 
        POP AX
        INC SI
        MOV [SI], AL
        LOOP LOOP2

    RET
            
HEX2DEC ENDP

TWO_D_DETERMINANT PROC
    
    MOV MANFI, 00H   
    MOV AL, FIRST_NUM
    MOV BL, FOURTH_NUM
    MUL BL
    MOV FIRST_NUM, AL
    
    MOV AL, SECOND_NUM
    MOV BL, THIRD_NUM
    MUL BL
    MOV SECOND_NUM, AL
    
    CMP AL, FIRST_NUM
    JA NATIJE_MANFI
    MOV AL, FIRST_NUM
    SUB AL, SECOND_NUM
    JMP END_TWO_D_DETERMINANT
    
    NATIJE_MANFI:
        MOV MANFI, 01H
        MOV AL,  SECOND_NUM
        SUB AL, FIRST_NUM
        JMP END_TWO_D_DETERMINANT
       
    END_TWO_D_DETERMINANT:   
    RET
    
TWO_D_DETERMINANT ENDP

INPUT_ELEMENTS PROC
    
    MOV CL,INPUT_ROW
    XOR BX,BX
    MOV SI, 2
    
    INPUTELEMENT:
         
        LEA DX, MSG2 ; PRINT MSG3 TO STANDARD OUTPUT.
        MOV AH, 9
        INT 21H
        CALL PRINTNUMBER
    
        LEA DX, MSG3 ; PRINT MSG4 TO STANDARD OUTPUT.
        MOV AH, 9
        INT 21H
    
        PUSH BX
        MOV BL,BH
        CALL PRINTNUMBER
        POP BX
    
        LEA DX, MSG4 ; PRINT MSG5 TO STANDARD OUTPUT.
        MOV AH, 9
        INT 21H

        MOV AH, 0AH ; READ THE INPUT. 
        LEA DX, RESULT
        INT 21h
    
        PUSH CX
        CALL PUSH_NUMBER
        POP CX
    
        LEA DX, NEW_LINE ; \n
        MOV AH, 9
        INT 21H
    
     
        INC BH
        MOV AL,INPUT_COL
        CMP BH,AL 
        JNE INPUTELEMENT
   
        MOV BH,0
        INC BL
    
        LOOP INPUTELEMENT
        
    RET
          
INPUT_ELEMENTS ENDP

PUSH_NUMBER PROC
    
    MOV DI, 2
    
    PUSH_NUMBER_LOOP:
        MOV AL,RESULT[DI]
        CMP AL, 0DH
        JE END_PUSH_NUMBER
        SUB AL, 30H
        MOV RES[SI], AL
        
        INC SI
        INC DI
        INC LEN0
        
        JMP PUSH_NUMBER_LOOP
        
    END_PUSH_NUMBER:
    RET   
    
PUSH_NUMBER ENDP

PRINTNUMBER PROC
    
    MOV AL, BL
    CMP AL, 0
    MOV DH, 0
    JNE PRINT_ANSWER
    MOV AL, '0'
    MOV AH, 0EH
    INT 10H
    JMP FINISH
    PRINT_ANSWER:
        PUSH AX
        MOV AH, 0
        CMP AX, 0
        JE PRINT_FINAL
        MOV DL, 10
        DIV DL
        INC DH
    JMP PRINT_ANSWER

    PRINT_FINAL:
        POP AX
        MOV AL, AH
        ADD AL, 30H
        MOV AH, 0EH
        INT 10H
        DEC DH
        CMP DH,0
        JNE PRINT_FINAL
    
    POP AX
    
    FINISH:
    RET
 
PRINTNUMBER ENDP

END MAIN