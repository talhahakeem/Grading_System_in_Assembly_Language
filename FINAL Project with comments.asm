include 'emu8086.inc'

JMP START

DATA SEGMENT 
    N       DW      ?                ;to store number of Students                                             
    MARKS   DB 100 DUP (?)           ; Array for Marks
    ID      DB 100 DUP (?)           ; Array for IDs
    GRADES  DB 100 DUP (?)           ; Array for Grades
         
    MSG     DB 0Dh,0Ah,0Dh,0Ah,'************  STUDENT GRADING SYSTEM  ************',0
    MSG1    DB 0Dh,0Ah,0Dh,0Ah,'Enter the number of students (DOES NOT EXCEED 100): ',0
    MSG2    DB 0Dh,0Ah,0Dh,0Ah,'Enter the IDs of students: ',0
    MSG3    DB 0Dh,0Ah,0Dh,0Ah,'Enter the marks of students(OUT OF 100): ',0    
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
    
    
    LEA SI, MSG
    CALL PRINT_STRING
        
   
    LEA SI, MSG1              
    CALL PRINT_STRING                                                         
    CALL SCAN_NUM           
    MOV N, CX         
    
  
    LEA SI, MSG2              ;5 students 
                                  ;1
    
    CALL PRINT_STRING
    MOV SI, 0            ;si=0 
                           ;2 student ki id la ga 
                           
LOOP1:                      2  
                              ;cl=2;  
                              ;4
                              

    CALL SCAN_NUM       ;first student ki id la ga
                        ;cl ma ay ga   1 cl=1;     
                        
                        ;  id [0]= 1; 
                        ; id [1]=2;
                        ;id[4]=4;
                        
                        
                        ;si=5;
    MOV ID[SI], CL
    INC SI  
    PRINT 0AH           ;si=1;
    PRINT 0DH        
    CMP SI, N            ;si=5,5  
                          ;si=2,5;
    
    JNE LOOP1             cmp-> subtract krti h source ko destinaTION  cmp statement result store ni krti just flags ko effect krti h 
                           5,5 0 zero flag on 
                           ;1,5
                           ;5-1=4
                           JNE ->  jump if not equal to 
                           
    
        
  
    LEA SI, MSG3
    CALL PRINT_STRING      ;id[0]=1; id[1]=2;id[3]=3;id[4]=4
                           ;marks[0]=90;marks[1]=89;marks[2]=93 .....
    MOV SI, 0
LOOP2:                     ;si=0;
    CALL SCAN_NUM          ;90
    MOV MARKS[SI], CL      ;cl=90;marks[0]=90;
    INC SI                  si=1;
    
    PRINT 0AH        
    PRINT 0DH        
    CMP SI, N 
    JNE LOOP2  
        
     ;Sorting marks by bubble sort
    DEC N                             ;N=5
    MOV CX, N                          ;N--;N=4;
OUTER:                                   CX=4;
    MOV SI, 0                           si=0;
INNER:                                                       ;90,89  89,9
                                        AL=89                           
                                        DL =2
                                        
    MOV AL, MARKS[SI]                  AL=marks[0]; AL=90; 
    MOV DL, ID[SI]                      DL=id[0];DL=1;
    INC SI                               si++;
    
    CMP MARKS[SI], AL                     si=2;
                                           marks[2]=93;     93,78
    JB  SKIP                               cmp 93,89
    
    XCHG AL, MARKS[SI]          ;89,93            JB-> 89 < 90 jump skip
    MOV MARKS[SI-1], AL         ;93,89
    XCHG DL, ID[SI]             marks[1]=93
    MOV ID[SI-1], DL             1,id[2];1,2;2,1    99,89,56,45
SKIP:                              id[1],dl
    CMP SI, CX            ;1,4;
    JL  INNER 
    LOOP OUTER
    
    INC N     
    
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
    PRINT 09H            
    MOV AL, MARKS[SI]
    CALL PRINT_NUM_UNS
    PRINT 09H           
    MOV AL, GRADES[SI]
    
    MOV AH, 0Eh      
    INT 10h            
    PRINT 0AH          
    PRINT 0DH        
    INC SI 
    CMP SI, N 
    JNE LOOP3


CODE ENDS
 
END START
