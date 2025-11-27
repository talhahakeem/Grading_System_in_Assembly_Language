include 'emu8086.inc'

JMP START

DATA SEGMENT 
    N      DW     ?                                                              
    MARKS  DB 1000 DUP (?)     ; 1000 is the maximum number of students
    ID     DB 1000 DUP (?)
    GRADES DB 1000 DUP (?)
             
    MSG1   DB 'Enter the number of students (does not exceed 1000): ', 0
    MSG2   DB 0Dh, 0Ah, 0Dh, 0Ah, 'Enter the IDs of students: ', 0
    MSG3   DB 0Dh, 0Ah, 0Dh, 0Ah, 'Enter the marks of students: ', 0
    HR     DB 0Dh, 0Ah, 0Dh, 0Ah, '******************* Sorted Marks ***********************', 0
    MSG4   DB 0Dh, 0Ah, 0Dh, 0Ah, 'ID: ', 09H, 'MARKS:', 09H, 'GRADE:', 0
DATA ENDS  

CODE SEGMENT
    ASSUME DS:DATA, CS:CODE     

    ; Setting data segment  
START: 
    MOV AX, DATA
    MOV DS, AX                    

    ; Defining functions for the library emu8086 which will be used later
    DEFINE_SCAN_NUM           
    DEFINE_PRINT_STRING 
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS
    
    ; Reading number of students
    LEA SI,MSG1   ; PRINT_STRING function prints what's in SI   
    CALL PRINT_STRING                                                        
    CALL SCAN_NUM ; The function puts the input in CX
    MOV N, CX

    ; Reading IDs of students  
    LEA SI,MSG2
    CALL PRINT_STRING
    MOV SI, 0
   
LOOP1: 
    CALL SCAN_NUM 
    MOV ID[SI], CL
    INC SI  
    PRINT 0AH  ; Print new line
    PRINT 0DH  ; Return cursor to the beginning 
    CMP SI, N 
    JNE LOOP1

    ; Reading marks of students
    LEA SI,MSG3
    CALL PRINT_STRING
    MOV SI, 0
   
LOOP2: 
    CALL SCAN_NUM 
    MOV MARKS[SI], CL
    INC SI  
    PRINT 0AH  ; Print new line
    PRINT 0DH  ; Return cursor to the beginning 
    CMP SI, N 
    JNE LOOP2

    ; Sorting them according to marks using bubble sort 
    DEC N   ; Because we won't compare the last element 
    MOV CX, N  ; CX as i
OUTER: 
    MOV SI, 0  ; SI as j

INNER: 
    MOV AL, MARKS[SI]
    MOV DL, ID[SI]
    INC SI
    CMP MARKS[SI], AL
    JB SKIP
    XCHG AL, MARKS[SI]
    MOV MARKS[SI-1], AL
    XCHG DL, ID[SI]
    MOV ID[SI-1], DL  
SKIP: 
    CMP SI, CX
    JL INNER 
    LOOP OUTER
    
    INC N ; We increment N again because we decreased it before    

    ; Assign grades based on marks
    MOV SI, 0
GRADING:
    MOV AL, MARKS[SI]
    CMP AL, 85
    JAE GRADE_A
    CMP AL, 80
    JAE GRADE_A_MINUS
    CMP AL, 75
    JAE GRADE_B_PLUS
    CMP AL, 71
    JAE GRADE_B
    CMP AL, 68
    JAE GRADE_B_MINUS
    CMP AL, 64
    JAE GRADE_C_PLUS
    CMP AL, 61
    JAE GRADE_C
    CMP AL, 58
    JAE GRADE_C_MINUS
    CMP AL, 54
    JAE GRADE_D_PLUS
    CMP AL, 50
    JAE GRADE_D
    JMP GRADE_F

GRADE_A:
    MOV GRADES[SI], 'A'
    JMP NEXT
GRADE_A_MINUS:
    MOV GRADES[SI], 'A'  ; Using 'A-' as just 'A' for simplicity
    JMP NEXT
GRADE_B_PLUS:
    MOV GRADES[SI], 'B'  ; Using 'B+' as just 'B' for simplicity
    JMP NEXT
GRADE_B:
    MOV GRADES[SI], 'B'
    JMP NEXT
GRADE_B_MINUS:
    MOV GRADES[SI], 'B'  ; Using 'B-' as just 'B' for simplicity
    JMP NEXT
GRADE_C_PLUS:
    MOV GRADES[SI], 'C'  ; Using 'C+' as just 'C' for simplicity
    JMP NEXT
GRADE_C:
    MOV GRADES[SI], 'C'
    JMP NEXT
GRADE_C_MINUS:
    MOV GRADES[SI], 'C'  ; Using 'C-' as just 'C' for simplicity
    JMP NEXT
GRADE_D_PLUS:
    MOV GRADES[SI], 'D'  ; Using 'D+' as just 'D' for simplicity
    JMP NEXT
GRADE_D:
    MOV GRADES[SI], 'D'
    JMP NEXT
GRADE_F:
    MOV GRADES[SI], 'F'
NEXT:
    INC SI
    CMP SI, N
    JNE GRADING

    ; Print table of their IDs, marks, and grades after sorting
    LEA SI,HR   
    CALL PRINT_STRING
    LEA SI,MSG4
    CALL PRINT_STRING
    PRINT 0AH  ; Print new line 
    PRINT 0DH  ; Return cursor to the beginning
   
    MOV SI, 0
LOOP3: 
    MOV AX, 0
    MOV AL, ID[SI]     
    CALL PRINT_NUM_UNS    
    PRINT 09H  ; Print tab
    MOV AL, MARKS[SI]
    CALL PRINT_NUM_UNS
    PRINT 09H  ; Print tab
    MOV DL, GRADES[SI]   ; Load grade into DL
    MOV AH, 02H           ; DOS interrupt to print character
    INT 21H
    PRINT 0AH  ; Print new line 
    PRINT 0DH  ; Return cursor to the beginning
    INC SI 
    CMP SI, N 
    JNE LOOP3
       
CODE ENDS
 
END START
START
