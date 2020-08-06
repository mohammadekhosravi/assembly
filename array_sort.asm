; ------------ARRAY SORT---------------
; THIS PROGRAM GET SIZE OF ARRAY AND EACH ELEMENT OF ARRAY AND THEN SORT ARRAY AND PRINT IT OUT.
.MODEL SMALL
.DATA
    MSG1 DB "ENTER SIZE OF ARRAY: $"
    MSG2 DB "SORTED ARRAY IS: (PRINTED VERTICALLY) $"
    LINE DB "---------------------------------------------$"
    ELEMENT_TO_PRINT DB "ELEMENT $" ; PRINT ELEMENT X.
    ELEMENT_COUNTER DB 00H ; COUNT NUMBER OF ELEMENTS.
    COLON DB " : $"
    NEW_LINE DB 0DH,0AH, '$'  ; NEW LINE CODE. 
    START_FIRST_NUMBER DW ? ; BECAUSE SI IN 16 BIT RIGISTER
    START_SECOND_NUMBER DW 0002H ; BECAUSE SI IN 16 BIT RIGISTER
    SIZE DB ? ; SIZE OF INPUT ARRAY
    
    INPUT LABEL BYTE ; EACH ONE OF USER INPUT COME HERE. MAXIMUM 50 DIGIT NUMBER.
    MAX DB 50
    LEN DB ?
    BUFFER DB 50 DUP('?')
    
    RESULT LABEL BYTE ; THE INFAMOUS ARRAY ITSELF.
    MAX1 DB 200
    LEN1 DB ?
    BUFFER1 DB 200 DUP('?')
    
    FIRST_NUMBER LABEL BYTE ; FIRST SELECTED NUMBER FROM ARRAY.
    MAX2 DB 1
    LEN2 DB 00H
    BUFFER2 DB 200 DUP('?')
    
    SECOND_NUMBER LABEL BYTE ; SECOND SELECTED NUMBER FROM ARRAY.
    MAX3 DB 1
    LEN3 DB 00H
    BUFFER3 DB 200 DUP('?')
    
    TEMP LABEL BYTE          ; TEMPORARY NUMBER FOR SWAPPING.
    MAX4 DB 1
    LEN4 DB 00H
    BUFFER4 DB 200 DUP('?')
    
    
.CODE
MAIN PROC
    
    MOV AX, @DATA ; INITIALIZATION OF DATA SEGMENT.
    MOV DS, AX 
    
    ; ------------------NUMBER OF ROWS------------------
    LEA DX, MSG1 ; PRINT MSG1 TO STANDARD OUTPUT.
    MOV AH, 9
    INT 21H
    
    MOV AH, 1 ; READ THE NMBER OF ROWS.
    INT 21H
    
    SUB AL, 30H ; CONVERT ASCII TO DECIMAL.
    MOV SIZE, AL ; STORE NOR VALUE.
    
    ; --------NEW LINE----------------------------------
    LEA DX, NEW_LINE
    MOV AH, 9
    INT 21H
    
    ; -------GET ARRAY'S ELEMENT FROM INPUT------------- 
    CALL GET_INPUT                                       
    
    ; ------------SORT ARRAY----------------------------
    CALL SORT_ARRAY
    
    ; ---------PRINT ARRAY------------------------------
    CALL PRINT_ARRAY
    
    ; ----------RETURN CONTROL TO OPERATING SYSTEM------
    MOV AX, 4C00H
    INT 21H
    
MAIN ENDP

SORT_ARRAY PROC
    ; WE USE NON-OPTIMIZED BUBBLE SORT HERE.
    SORT_ARRAY_OUTER_LOOP:
        
        DEC SIZE
        CALL INNER_LOOP
        CMP SIZE, 0
        JE GO_BACK
        JMP SORT_ARRAY_OUTER_LOOP
    
    GO_BACK:
    RET
    
SORT_ARRAY ENDP

INNER_LOOP PROC
   
   XOR CX, CX
   MOV CL, LEN1
   MOV LEN2, 00H
   MOV START_SECOND_NUMBER, 2 ; SO SI=2 BECAUSE AFTER EACH OUTER LOOP WE NEED TO START FROM FIRST ARRAY'S ELEMENT.
   
   SORT_ARRAY_INNER_LOOP:
       
       SUB CL, LEN2 ; HOW MUCH DIGIT YOU PROCEED.
       MOV SI, START_SECOND_NUMBER ; AFTER CMP ARRAY[I], ARRAY[I + 1] WE WANT TO CMP ARRAY[I + 1], ARRAY[I + 2]
       CALL SORT_UTIL
       
       LOOP SORT_ARRAY_INNER_LOOP

   RET    
    
INNER_LOOP ENDP

SORT_UTIL PROC
   ; GIVEN <I> COMPARE AND SWAP ARRAY[I], ARRAY[I + 1] IF NEEDED.
   PUSH CX
    
   MOV LEN2, 00H
   MOV LEN3, 00H
   MOV LEN4, 00H
   
   ; CLEAR BUFFERS
   CLEAR_BUFFER2:
       MOV DI, 2
       
       CLEAR_BUFFER2_LOOP:
       
           MOV BL, FIRST_NUMBER[DI]
           CMP BL, 3FH
           JE CLEAR_BUFFER3
       
           MOV FIRST_NUMBER[DI], 3FH
           INC DI
       
           JMP CLEAR_BUFFER2_LOOP
       

   CLEAR_BUFFER3:
       MOV DI, 2
       
       CLEAR_BUFFER3_LOOP:
           MOV BL, SECOND_NUMBER[DI]
           CMP BL, 3FH
           JE CLEAR_BUFFER4
       
           MOV SECOND_NUMBER[DI], 3FH
           INC DI
       
           JMP CLEAR_BUFFER3_LOOP
   
   CLEAR_BUFFER4:
       MOV DI, 2
       
       CLEAR_BUFFER4_LOOP:
           MOV BL, TEMP[DI]
           CMP BL, 3FH
           JE SET_DI_FN
       
           MOV TEMP[DI], 3FH
           INC DI
       
           JMP CLEAR_BUFFER4_LOOP
   
   SET_DI_FN:
       MOV START_FIRST_NUMBER, SI ; STORE ADDRESS OF FIRST NUMBER FOR SWAPPING.
       MOV DI, 2
       JMP FN
   FN:
       MOV BL, RESULT[SI]
       INC SI
       CMP BL, 0DH ; COMPARE WITH CARRIGE RETURN
       JE SET_DI_SN
       
       MOV FIRST_NUMBER[DI], BL
       INC LEN2
       
       
       INC DI
       
       JMP FN
          
   SET_DI_SN:
       MOV START_SECOND_NUMBER, SI ; STORE ADDRESS OF SECOND NUMBER FOR SWAPPING.
       MOV DI, 2
       JMP SN
   SN: 
       MOV BL, RESULT[SI + 1]
       CMP BL, 3FH
       JE END_ARRAY ; CHANGE VALUE OF CL TO 1 BECAUSE WE REACH TO END OF ARRAY.
       MOV BL, RESULT[SI]
       INC SI
       CMP BL, 0DH ; COMPARE WITH CARRIGE RETURN
       JE  COMPARE
       ;CMP BL, 3FH ; END OF ARRAY
       ;JE CONTINUE
       
       MOV SECOND_NUMBER[DI], BL
       INC LEN3
       
       INC DI
       
       JMP SN
       
   ;END_ARRAY:
   ;    MOV CL, 1
   ;    JMP COMPARE
   END_ARRAY:
       POP CX
       MOV CX, 1 ; WE REACH THE END OF ARRAY SO WE NEED TO EXIT FROM OUTER LOOP.
       PUSH CX
       JMP COMPARE
           
   COMPARE:
       MOV AL, LEN2
       CMP AL, LEN3 ; FIRST COMPARE LENGTH OF NUMBERS.
       JA SWAP     ; IF FIRST NUMBER IS BIGGER GO SWAP THEM.
       JB CONTINUE ; IF SECOND NUMBER IS BIGGER DON'T DO ANY SWAPPING.
       MOV DI, 2
       
       ;PUSH CX
       MOV CL, LEN2
       
       COMPARE_LOOP: ; THEN COMPARE EACH DIGIT ON NUMBERS.
           MOV AL, FIRST_NUMBER[DI]
           CMP AL, SECOND_NUMBER[DI]
           JA SWAP  ; IF FIRST NUMBER IS BIGGER GO SWAP THEM.
           JB CONTINUE ; IF SECOND NUMBER IS BIGGER DON'T DO ANY SWAPPING. 
           
           INC DI
           
           LOOP COMPARE_LOOP
           
       ;POP CX
       JMP CONTINUE
               
   SWAP:
       ; WE DO SWAPPING LIKE IN C.
       ; AND BECAUSE WE USE BUBLE SORT WE JUST SWAP TWO ADJACENT NUMBERS.
       ; FIRST_NUMBER -> TEMP
       ; SECOND_NUMBER -> FIRST_NUMBER
       ; TEMP -> SECOND_NUMBER
       PUSH SI
       
       ;-------------FINRST_NUMBER -> TEMP ----------
       MOV SI, 2
       MOV DI, 2
       MOV CL, LEN2
       
       FIRST_TO_TEMP_LOOP:
           MOV BL, FIRST_NUMBER[SI]
           MOV TEMP[DI], BL
           
           INC LEN4
           INC SI
           INC DI
           
           LOOP FIRST_TO_TEMP_LOOP    
       
       ;----------SECOND_NUMBER -> FIRST_NUMBER--------
       MOV DI, START_FIRST_NUMBER
       MOV SI, 2
       MOV CL, LEN3
       
       SECOND_TO_FIRST_LOOP:
           MOV BL, SECOND_NUMBER[SI]
           MOV RESULT[DI], BL ; REMEMBER THAT WE SWAP NUMBER INSIDE THE ARRAY ITSELF.
           
           INC SI
           INC DI
           
           LOOP SECOND_TO_FIRST_LOOP
       MOV RESULT[DI], 0DH
       INC DI
       ;------------TEMP -> SECOND_NUMBER-------------- 
       MOV START_SECOND_NUMBER, DI
       ;MOV DI, START_SECOND_NUMBER
       MOV SI, 2
       MOV CL, LEN4
       
       TEMP_TO_SECOND_LOOP:
           MOV BL, TEMP[SI]
           MOV RESULT[DI], BL
           
           INC SI
           INC DI
           
           LOOP TEMP_TO_SECOND_LOOP
       MOV RESULT[DI], 0DH                                             
                                                    
       POP SI
       JMP CONTINUE
   

       
   CONTINUE:
       POP CX
       
       RET
    
SORT_UTIL ENDP

GET_INPUT PROC

   XOR CX, CX
   MOV CL, SIZE ; SET COUNTER TO SIZE OF ARRAY
   
   ROW:
       ; --------NEW LINE-----------
       LEA DX, NEW_LINE
       MOV AH, 9
       INT 21H
       
       ; PRINT "ELENET X".
       LEA DX, ELEMENT_TO_PRINT
       MOV AH, 9
       INT 21H
       
       ; PRINT THE X PART.
       MOV BL, ELEMENT_COUNTER
       ADD BL, 30H
       MOV AH, 2
       MOV DL, BL
       INT 21H
       
       INC ELEMENT_COUNTER
       
       ; PRINT " : "
       LEA DX, COLON
       MOV AH, 9
       INT 21H
       
       ; GET INPUT FROM USER
       LEA DX, INPUT
       MOV AH, 0AH
       INT 21H
       
       CALL PUSH_NUMBER
       
       ;MOV [SI], AL
       ;ADD SI, 2 ; BECAUSE ARRAY IS WORD(2 BYTE).
       
       LOOP ROW
   
   
   ; RESTORE REGISTERS VALUE FROM STACK.
 
   RET 
    
GET_INPUT ENDP

PUSH_NUMBER PROC
    
   ; SAVE REGISTERS VALUE IN STACK. 
   PUSH CX
   
   XOR SI, SI
   XOR DI, DI
   XOR AX, AX
   XOR CX, CX
   
   MOV CL, LEN
   INC CL
   
   MOV DI, AX
   ADD DI, 2
   
   XOR AX, AX
   MOV AL, LEN1
   MOV SI, AX
   ADD SI, 2
   ADD LEN1, CL
   
   DIGIT:
       MOV AL, INPUT[DI]
       MOV RESULT[SI], AL
       INC DI
       INC SI
       
       LOOP DIGIT
   
   ; RESTORE REGISTERS VALUE FROM STACK.
   POP CX
   RET
    
PUSH_NUMBER ENDP

PRINT_ARRAY PROC
    
   ; SAVE REGISTERS VALUE IN STACK. 
   PUSH CX
     
   LEA DX, NEW_LINE ; \N
   MOV AH, 9
   INT 21H
   
   LEA DX, NEW_LINE ; \N
   MOV AH, 9
   INT 21H
   
   LEA DX, LINE ; -------------------------------------------
   MOV AH, 9
   INT 21H
   
   LEA DX, NEW_LINE ; \N
   MOV AH, 9
   INT 21H
   
   LEA DX, NEW_LINE ; \N
   MOV AH, 9
   INT 21H
   
   LEA DX, MSG2
   MOV AH, 9
   INT 21H
   
   LEA DX, NEW_LINE ; \N
   MOV AH, 9
   INT 21H
       
   MOV SI, 2 ; BECAUSE TWO FIRST ELEMENT OF ARRAY ARE NOT INPUT NUMBERS.
   XOR CX, CX
   MOV CL, LEN1
   
   PRINT:
       MOV BL, RESULT[SI]
       INC SI
       
       CMP BL, 0DH ; COMPARE WITH CARRIGE RETURN
       JNE PRINT_NUM
       
       LEA DX, NEW_LINE ; \N
       MOV AH, 9
       INT 21H
   
   PRINT_NUM:
       ; ANOTHER WAY TO PRINT A CHARACTER
       ;MOV AH, 2
       ;MOV DL, BL
       ;INT 21H
       MOV AL, BL
       MOV AH, 0EH
       INT 10H
   
   LOOP PRINT
   
   ; RESTORE REGISTERS VALUE FROM STACK.
   POP CX
   
   RET
    
PRINT_ARRAY ENDP

END MAIN ; THE VERY LAST LINE