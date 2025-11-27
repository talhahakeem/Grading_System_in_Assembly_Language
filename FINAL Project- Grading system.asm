include 'emu8086.inc'

JMP START

DATA SEGMENT 
    N       DW      ?                                                              
    MARKS   DB 1000 DUP (?)           ; Array for Marks
    ID      DB 1000 DUP (?)           ; Array for IDs
    GRADES  DB 1000 DUP (?)           ; Array for Grades
         
    ; Enhanced UI Messages
    MSG     DB 0Dh,0Ah,0Dh,0Ah,'************  STUDENT GRADING SYSTEM  ************',0
    MSG1    DB 0Dh,0Ah,0Dh,0Ah,'Enter the number of students (DOES NOT EXCEED 100): ',0
    MSG2    DB 0Dh,0Ah,0Dh,0Ah,'Enter the IDs of students: ',0
    MSG3    DB 0Dh,0Ah,0Dh,0Ah,'Enter the marks of students: ',0    
    HR      DB 0Dh,0Ah,'******************* SORTED MARKS AND GRADES ***********************',0
    MSG4    DB 0Dh,0Ah,'ID: ',09H,'MARKS:',09H,'GRADES:',0                                 
DATA ENDS  

CODE SEGMENT
    ASSUME DS:DATA CS:CODE     

START:  
    MOV AX, DATA
    MOV DS, AX                    
   
    DEFINE_SCAN_NUM           
    DEFINE_PRINT_STRING 
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS
    
    ; Display Title and Border
    LEA SI, MSG
    CALL PRINT_STRING
        
    ; Reading number of students
    LEA SI, MSG1              
    CALL PRINT_STRING                                                         
    CALL SCAN_NUM            ; Input stored in CX
    MOV N, CX
    
    ; Reading IDs of students  
    LEA SI, MSG2
    CALL PRINT_STRING
    MOV SI, 0
LOOP1:   
    CALL SCAN_NUM 
    MOV ID[SI], CL
    INC SI  
    PRINT 0AH        
    PRINT 0DH        
    CMP SI, N 
    JNE LOOP1
        
    ; Reading marks of students
    LEA SI, MSG3
    CALL PRINT_STRING
    MOV SI, 0
LOOP2:   
    CALL SCAN_NUM 
    MOV MARKS[SI], CL
    INC SI  
    PRINT 0AH        
    PRINT 0DH        
    CMP SI, N 
    JNE LOOP2  
        
    ; Sorting by marks using bubble sort 
    DEC N            ; Because last element does not require comparison 
    MOV CX, N       ; CX as i
OUTER:   
    MOV SI, 0       ; SI as j
INNER:   
    MOV AL, MARKS[SI]
    MOV DL, ID[SI]
    INC SI
    CMP MARKS[SI], AL
    JB  SKIP
    XCHG AL, MARKS[SI]
    MOV MARKS[SI-1], AL
    XCHG DL, ID[SI]
    MOV ID[SI-1], DL  
SKIP:   
    CMP SI, CX
    JL  INNER 
    LOOP OUTER
    
    INC N           ; Restore N to original value    
    
    ; Calculating grades
    MOV SI, 0
CALC_GRADES:
    CMP SI, N
    JAE END_CALC
    MOV AL, MARKS[SI]
    CMP AL, 85
    JAE GRADE_A
    CMP AL, 75
    JAE GRADE_B
    CMP AL, 65
    JAE GRADE_C
    CMP AL, 50
    JAE GRADE_D
    JMP GRADE_F

GRADE_A:
    MOV GRADES[SI], 'A'
    JMP NEXT

GRADE_B:
    MOV GRADES[SI], 'B'
    JMP NEXT

GRADE_C:
    MOV GRADES[SI], 'C'
    JMP NEXT

GRADE_D:
    MOV GRADES[SI], 'D'
    JMP NEXT

GRADE_F:
    MOV GRADES[SI], 'F'

NEXT:
    INC SI
    JMP CALC_GRADES
END_CALC:

    ; Print sorted table
    LEA SI, HR   
    CALL PRINT_STRING
    LEA SI, MSG4
    CALL PRINT_STRING
    PRINT 0AH            
    PRINT 0DH           
    
    MOV SI, 0
LOOP3:   
    MOV AX, 0
    MOV AL, ID[SI]     
    CALL PRINT_NUM_UNS    
    PRINT 09H            ; Print tab
    MOV AL, MARKS[SI]
    CALL PRINT_NUM_UNS
    PRINT 09H            ; Print tab
    MOV AL, GRADES[SI]
    ; Print grade character directly
    MOV AH, 0Eh         ; BIOS teletype function
    INT 10h             ; Print character in AL
    PRINT 0AH            ; Print new line
    PRINT 0DH            ; Return cursor to beginning
    INC SI 
    CMP SI, N 
    JNE LOOP3

    ; Final border for clarity

CODE ENDS
 
END START
