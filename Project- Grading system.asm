include 'emu8086.inc'

JMP START

DATA SEGMENT 
    N       DW      ?                                                              
    MARKS   DB 1000 DUP (?)           ; 1000 IS THE MAXIMUM NUMBER OF STUDENTS
    ID      DB 1000 DUP (?)           ; Array for IDs
    GRADES  DB 1000 DUP (?)           ; Array for grades
         
    MSG1    DB 'Enter the number of students (DOES NOT EXCEED 1000): ',0
    MSG2    DB 0Dh,0Ah, 0Dh,0Ah,'Enter the IDs of students: ',0
    MSG3    DB 0Dh,0Ah, 0Dh,0Ah,'Enter the marks of students: ',0    
    HR      DB 0Dh,0Ah, 0Dh,0Ah,'******************* Sorted Marks ***********************',0
    MSG4    DB 0Dh,0Ah, 0Dh,0Ah,'ID: ',09H,'MARKS:',09H,'GRADES:',0                                 
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
        
    ; READING NUMBER OF STUDENTS
    LEA SI, MSG1              
    CALL PRINT_STRING                                                         
    CALL SCAN_NUM            ; THE FUNCTION PUTS THE INPUT IN CX
    MOV N, CX
    
    ; READING IDs OF STUDENTS  
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
        
    ; READING MARKS OF STUDENTS
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
        
    ; SORTING THEM ACCORDING TO MARKS USING BUBBLE SORT 
    DEC N            ; BECAUSE WE WON'T COMPARE THE LAST ELEMENT 
    MOV CX, N       ; CX AS I
OUTER:   
    MOV SI, 0       ; SI AS J
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
    
    INC N                   ; WE INCREMENT N AGAIN BECAUSE WE DECREASED IT BEFORE    
    
    ; CALCULATING GRADES
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

    ; PRINT TABLE OF THEIR IDs, MARKS, AND GRADES AFTER SORTING
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
    PRINT 09H            ; PRINT TAB
    MOV AL, MARKS[SI]
    CALL PRINT_NUM_UNS
    PRINT 09H            ; PRINT TAB
    MOV AL, GRADES[SI]
    ; Print the grade character directly
    MOV AH, 0Eh         ; BIOS teletype function
    INT 10h             ; Print character in AL
    PRINT 0AH            ; PRINT NEW LINE 
    PRINT 0DH            ; RETURN CURSOR TO THE BEGINNING
    INC SI 
    CMP SI, N 
    JNE LOOP3
       
CODE ENDS
 
END START
