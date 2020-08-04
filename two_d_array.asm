; ----------2D MATRIX----------------
; IN THIS PROGRAM ALL INPUTS ARE ONE DIGIT NUMBERS(UNDEFINED BEHAVIOUR IN CASE OF NOT).
.MODEL SMALL
.DATA
    MSG1 DB "ENTER NUMBER OF ROWS: $"
    MSG2 DB "ENTER NUMBER OF COLUMNS: $"
    NOR DB ? ; NUMBER OF ROWS.
    NOC DB ? ; NUMBER OF COLUMNS.
    ROW_COUNTER DB 00H ; COUNT NUMBER OF ROWS.
    COLUMN_COUNTER DB 00H ; COUNT NUMBER OF COLUMNS.
    ROW_TO_OUTPUT DB "ROW$" ; PRINT ROW
    COLUMN_TO_OUTPUT DB " COLUMN$" ; PRINT COLUMN
    TAB DB "    $"
    SPACE DB " : $"
    NEW_LINE DB 0DH,0AH, '$'  ; NEW LINE CODE.
    
    ARRAY DW 9, 9 DUP('?')
          DW 9, 9 DUP('?')
          DW 9, 9 DUP('?')
          DW 9, 9 DUP('?')
          DW 9, 9 DUP('?')
          DW 9, 9 DUP('?')
          DW 9, 9 DUP('?')
          DW 9, 9 DUP('?')
          DW 9, 9 DUP('?')
    
.CODE
MAIN PROC
    
    MOV AX, @DATA
    MOV DS, AX ; INITIALIZATION OF DATA SEGMENT.
    
    ; ------NUMBER OF ROWS------
    LEA DX, MSG1 ; PRINT MSG1 TO STANDARD OUTPUT.
    MOV AH, 9
    INT 21H
    
    MOV AH, 1 ; READ THE NMBER OF ROWS.
    INT 21H
    
    SUB AL, 30H ; CONVERT ASCII TO DECIMAL.
    MOV NOR, AL ; STORE NOR VALUE.
    
    ; --------NEW LINE-----------
    LEA DX, NEW_LINE
    MOV AH, 9
    INT 21H
    
    ; -----NUMBER OF COLUMNS------
    LEA DX, MSG2 ; PRINT MSG1 TO STANDARD OUTPUT.
    MOV AH, 9
    INT 21H
    
    MOV AH, 1 ; READ THE NMBER OF COLUMNS.
    INT 21H
    
    SUB AL, 30H ; CONVERT ASCII TO DECIMAL.
    MOV NOC, AL ; STORE NOC VALUE.
    
    LEA SI, ARRAY ; SET SI=OFFSET ADDRESS OF ARRAY 
    CALL GET_INPUT
    
    
    LEA SI, ARRAY ; SET SI=OFFSET ADDRESS OF ARRAY
    CALL PRINT_2D_ARRAY
    
    
    MOV AX, 4C00H
    INT 21H
        
MAIN ENDP


GET_INPUT PROC
    XOR CX, CX
    MOV CL, NOR
    
    INPUT_ALL:
        CALL GET_ROW
        
        LOOP INPUT_ALL
        
        RET
GET_INPUT ENDP

GET_ROW PROC
    PUSH CX
    MOV CL, NOC ; SET COUNTER TO NUMBER OF COLUMNS.
    MOV COLUMN_COUNTER, 00H
    
    ROW:
        ; --------NEW LINE-----------
        LEA DX, NEW_LINE
        MOV AH, 9
        INT 21H
        
        LEA DX, ROW_TO_OUTPUT
        MOV AH, 9
        INT 21H
        
        MOV BL, ROW_COUNTER
        ADD BL, 30H
        MOV AH, 2
        MOV DL, BL
        INT 21H
         
        LEA DX, COLUMN_TO_OUTPUT
        MOV AH, 9
        INT 21H
        
        MOV BL, COLUMN_COUNTER
        ADD BL, 30H
        MOV AH, 2
        MOV DL, BL
        INT 21H
        
        LEA DX, SPACE
        MOV AH, 9
        INT 21H
        
        MOV AH, 1
        INT 21H
        
        MOV [SI], AL
        ADD SI, 2 ; BECAUSE ARRAY IS WORD(2 BYTE).
        
        INC COLUMN_COUNTER
        
        LOOP ROW
        
        INC ROW_COUNTER
        POP CX
        
        RET
           
GET_ROW ENDP

PRINT_2D_ARRAY PROC
    
    XOR CX, CX
    MOV CL, NOR
    
    ALL:
        ; --------NEW LINE-----------
        LEA DX, NEW_LINE
        MOV AH, 9
        INT 21H
        
        CALL PRINT_ROW
        
        LOOP ALL
        
        RET
       
PRINT_2D_ARRAY ENDP

PRINT_ROW PROC
    
    PUSH CX
    MOV CL, NOC ; SET COUNTER TO NUMBER OF COLUMNS.
    
    ROW1:
        
        MOV BL, [SI] 
        ADD SI, 2 ; BECAUSE ARRAY IS WORD(2 BYTE).
        
        MOV AH, 2
        MOV DL, BL
        INT 21H
        
        LEA DX, TAB
        MOV AH, 9
        INT 21H
        
        LOOP ROW1
        POP CX
        RET
      
PRINT_ROW ENDP

END MAIN ; THE VERY LAST LINE.