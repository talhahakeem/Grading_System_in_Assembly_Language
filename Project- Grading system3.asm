include 'emu8086.inc'

JMP START

DATA SEGMENT
    N        DW  ?                 ; Number of students
    MARKS    DB  1000 DUP (?)      ; Marks of students (max 1000 students)
    ID       DB  1000 DUP (?)      ; IDs of students (max 1000 students)
    GRADE    DB  1000 DUP (?)      ; Grades of students (max 1000 students)
            
    MSG1     DB 0Dh,0Ah,0Dh,0Ah,'Enter the number of students (DOES NOT EXCEED 1000): ',0
    MSG2     DB 0Dh,0Ah,0Dh,0Ah,'Enter the IDs of students: ',0
    MSG3     DB 0Dh,0Ah,0Dh,0Ah,'Enter the marks of students: ',0
    HR       DB 0Dh,0Ah,0Dh,0Ah,'******************************************************',0
    HEADER   DB 0Dh,0Ah,0Dh,0Ah,'******************* STUDENTS GRADES ******************',0
    LINE     DB 0Dh,0Ah, '------------------------------------------------------------',0
    MSG4     DB 0Dh,0Ah, 'ID: ',09H, 'MARKS: ',09H, 'GRADE: ',0
DATA ENDS  

CODE SEGMENT
    ASSUME DS:DATA, CS:CODE

START:
    ; Initialize data segment
    MOV AX, DATA
    MOV DS, AX

    ; Define functions from emu8086 library
    DEFINE_SCAN_NUM
    DEFINE_PRINT_STRING
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS

    ; Read the number of students
    LEA SI, MSG1
    CALL PRINT_STRING
    CALL SCAN_NUM
    MOV N, CX

    ; Read IDs of students
    LEA SI, MSG2
    CALL PRINT_STRING
    MOV SI, 0

READ_IDS:
    CALL SCAN_NUM
    MOV ID[SI], CL
    INC SI
    PRINT 0AH          ; Print newline
    PRINT 0DH          ; Return cursor to the beginning
    CMP SI, N
    JNE READ_IDS

    ; Read marks of students
    LEA SI, MSG3
    CALL PRINT_STRING
    MOV SI, 0

READ_MARKS:
    CALL SCAN_NUM
    MOV MARKS[SI], CL
    INC SI
    PRINT 0AH          ; Print newline
    PRINT 0DH          ; Return cursor to the beginning
    CMP SI, N
    JNE READ_MARKS

    ; Sort students by marks using bubble sort
    DEC N              ; Adjust N for zero-based index
    MOV CX, N          ; CX as counter for outer loop

SORT_OUTER:
    MOV SI, 0          ; SI as inner loop index

SORT_INNER:
    MOV AL, MARKS[SI]
    MOV DL, ID[SI]
    MOV DH, GRADE[SI]
    INC SI
    CMP MARKS[SI], AL
    JB SKIP_SWAP
    XCHG AL, MARKS[SI]
    MOV MARKS[SI-1], AL
    XCHG DL, ID[SI]
    MOV ID[SI-1], DL
    XCHG DH, GRADE[SI]
    MOV GRADE[SI-1], DH

SKIP_SWAP:
    CMP SI, CX
    JL SORT_INNER
    LOOP SORT_OUTER

    INC N              ; Re-adjust N after sorting

    ; Assign grades based on marks
    MOV SI, 0

ASSIGN_GRADE:
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
    MOV GRADE[SI], 'A'
    JMP NEXT_STUDENT

GRADE_B:
    MOV GRADE[SI], 'B'
    JMP NEXT_STUDENT

GRADE_C:
    MOV GRADE[SI], 'C'
    JMP NEXT_STUDENT

GRADE_D:
    MOV GRADE[SI], 'D'
    JMP NEXT_STUDENT

GRADE_F:
    MOV GRADE[SI], 'F'

NEXT_STUDENT:
    INC SI
    CMP SI, N
    JNE ASSIGN_GRADE

    ; Print header and table of IDs, Marks, and Grades after sorting
    LEA SI, HEADER
    CALL PRINT_STRING
    LEA SI, LINE
    CALL PRINT_STRING
    LEA SI, MSG4
    CALL PRINT_STRING
    LEA SI, LINE
    CALL PRINT_STRING
    PRINT 0AH            ; Print newline
    PRINT 0DH            ; Return cursor to the beginning

    MOV SI, 0

PRINT_RESULTS:
    MOV AX, 0
    MOV AL, ID[SI]
    CALL PRINT_NUM_UNS
    PRINT 09H            ; Print tab
    MOV AL, MARKS[SI]
    CALL PRINT_NUM_UNS
    PRINT 09H            ; Print tab

    ; Print grade
    MOV AL, GRADE[SI]
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    PRINT 0AH            ; Print newline
    PRINT 0DH            ; Return cursor to the beginning
    INC SI
    CMP SI, N
    JNE PRINT_RESULTS

    LEA SI, LINE
    CALL PRINT_STRING

CODE ENDS

END START
