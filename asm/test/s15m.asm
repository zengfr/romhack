;TITLE MASM  8086 Code Template (masm for dos EXE file)
 
;       AUTHOR          zengf https://github.com/zengfr/romhack
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM
 
 
 
DSEG    SEGMENT 'DATA'
 
; TODO: add your data here!!!!
 
string_fun1 db 100 dup(?)
	    db '$'
string_fun1_result db 100 dup(?)
	    db '$'
string_fun2 db 100 dup(?)
	    db '$'
string_fun2_result db 10 dup(?)
	           db '$'	    
string_fun2_result2 db 'the maximum is :$'
string_fun3 db 100 dup(?)
	    db '$'
string_fun4 db 'Now the time is :$'
string_time db ':$'
	    db '$'
string_main db 'plase input the function number (1~5)$'
string_error db 'Wrong number, plase input again: $'
string_next_fun db 'What do you want to do next? space/any other key: $'
string_broken db 'The pro is broken, Ple. run again $'
string_input_character db 'Please input character : $'
string_input_error db 'error please input 0~9 a~z A~Z $'
string_fun3_info db 'Please input the numbers:',0DH,0AH,'$'
string_fun3_error db 'error $'
string_fun3_hex db 100 dup(?)
	        db '$'
string_fun3_count db 10 dup(?)
	        db '$'
string_fun3_result db 100 dup(?)	        
	           db '$'
string_fun3_hexcopy db 100 dup(?)	        
	            db '$'	
	            
STRDEC  DB 'DEC:','$'
STRHEX  DB 'HEX:','$'
        	                    
string_fun4_info db 'please press anykey to display the time $'
 
string_doing_func1 db 'Now we are doing function_1: $'
string_doing_func2 db 'Now we are doing function_2: $'
string_doing_func3 db 'Now we are doing function_3: $'
string_doing_func4 db 'Now we are doing function_4: $'
 
;****************hongdingyi**********************
 
change_line macro
    mov    ah,2
    mov    dl,0dh
    int    21h
    mov    ah,2
    mov    dl,0ah
    int    21h
    endm
 
disp_line macro    string
    lea    dx,string
    mov    ah,09h
    int    21h
    endm
 
get_char macro
    mov    ah,1
    int    21h
;    CMP    AL,1BH  	;判断是否按下esc 
;    JE     main_menu
    endm
 
 
DSEG    ENDS
 
SSEG    SEGMENT STACK   'STACK'
        DW      100h    DUP(?)
SSEG    ENDS
 
CSEG    SEGMENT 'CODE'
	assume cs:CSEG,ds:DSEG,es:DSEG,ss:SSEG
;*******************************************
 
START   PROC    FAR
 
; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX
 
; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX
 
; TODO: add your code here!!!!
main_menu:
    change_line
    disp_line string_main
    get_char
 
    cmp    al,31h
    jb     disp_input_errer
    cmp    al,35h
    ja     disp_input_errer
    jmp    func_sel
    
disp_input_errer:
    change_line
    disp_line string_error
    jmp    main_menu    
    
func_sel:    
    sub    al,30h
    mov    bl,al
    cmp    al,01h
    jne    func2_5 
    jmp    func_1
    
func2_5:
    cmp    al,02h
    jne    func3_5
    jmp    func_2    
    
func3_5:
    cmp    al,03h
    jne    func4_5
    jmp    func_3
    
func4_5:    
    cmp    al,04h
    jne    func5
    jmp    func_4
        
func5:    
    cmp    al,05h
    jne    func_next
    jmp    func_5
    
func_next:    
    mov    ah,2
    mov    dl,0dh
    int    21h
    lea    DX,string_broken
    mov    ah,09h
    int    21h
    jmp    main_menu
    
;***************func_1***********************
func_1:
    change_line
    disp_line string_doing_func1
    change_line
    disp_line string_input_character
    lea    si,string_fun1
    mov    cl,00h
    
restore_input:    
    get_char
    mov    bl,al
    cmp    al,0dh
    je     do_func1
    cmp    al,20h
    jne    func_1_next
    jmp    main_menu
    
func_1_next:
    cmp    al,30h
    jb     input_error
    cmp    al,39h
    jbe    real_store
    cmp    al,41h
    jb     input_error
    cmp    al,5ah
    jbe    real_store
    cmp    al,61h
    jb     input_error    
    cmp    al,7ah
    jbe    real_store    
    
input_error:
    change_line
    disp_line string_doing_func1
    change_line
    disp_line string_input_character
    jmp    restore_input
    
real_store:     
    mov    al,bl
    mov    [si],al
    inc    si
    inc    cl
    inc    di
    jmp    restore_input
    
do_func1:    
    lea    si,string_fun1
    lea    di,string_fun1_result
    
cmp_data:    
    cmp    cl,00h    
    je     func1_finish
    mov    al,[si]
    cmp    al,61h
    jb     cmp_data_finish
    sub    al,20h
    
cmp_data_finish:
    mov    [di],al
    inc    si
    dec    cl
    inc    di
    jmp    cmp_data
    
func1_finish:
    change_line
    mov    [si],'$'    
    mov    [di],'$'
    disp_line string_fun1
    change_line
    disp_line string_fun1_result
    change_line
    
    disp_line string_next_fun    
    get_char
    
    cmp    al,020h
    jnz    do_fun1_again
    mov    ax,00h
    mov    si,ax
    mov    di,ax
    jmp    main_menu
    
do_fun1_again:    
    mov    ax,00h
    mov    si,ax
    mov    di,ax
    mov    ah,2
    mov    dl,0dh
    int    21h    
    jmp    func_1
    
 
;***************func_2***********************
func_2:
    change_line
    disp_line string_doing_func2
    change_line
    disp_line string_input_character
    lea    si,string_fun2
    mov    cl,00h
    
func_2_restore_input:    
    get_char
    mov    bl,al
    cmp    al,0dh
    je     do_func2
    cmp    al,20h
    jne    func_2_next
    jmp    main_menu
    
func_2_next:
    cmp    al,30h
    jb     func_2_input_error
    cmp    al,39h
    jbe    func_2_real_store
    cmp    al,41h
    jb     func_2_input_error
    cmp    al,5ah
    jbe    func_2_real_store
    cmp    al,61h
    jb     func_2_input_error    
    cmp    al,7ah
    jbe    func_2_real_store    
    
func_2_input_error:
    change_line
    disp_line string_doing_func2
    change_line
    disp_line string_input_character
    jmp    func_2_restore_input
    
func_2_real_store:     
    mov    al,bl
    mov    [si],al
    inc    si
    inc    cl
    jmp    func_2_restore_input
    
do_func2:    
    lea    si,string_fun2
    lea    di,string_fun2_result    
    mov    al,[si]
    mov    [di],al
    inc    si
    dec    cl
    
func_2_cmp_data:    
    cmp    cl,00h    
    je     func2_finish
    mov    al,[si]
    mov    ah,[di]
    cmp    al,ah
    ja     func_2_cmp_data_finish
    inc    si
    dec    cl
    jmp    func_2_cmp_data
    
func_2_cmp_data_finish:
    mov    [di],al
    inc    si
    dec    cl
    jmp    func_2_cmp_data
    
func2_finish:
    change_line
    mov    [si],'$'
    inc    di    
    mov    [di],'$'
    disp_line string_fun2_result2
    disp_line string_fun2_result
    change_line
    
    disp_line string_next_fun    
    get_char
    
    cmp    al,020h
    jnz    do_fun2_again
    mov    ax,00h
    mov    si,ax
    mov    di,ax
    jmp    main_menu
    
do_fun2_again:    
    mov    ax,00h
    mov    si,ax
    mov    di,ax
    mov    ah,2
    mov    dl,0dh
    int    21h    
    jmp    func_2
    
 
;***************func_3***********************
func_3:
    change_line
    disp_line string_doing_func3
    change_line
    disp_line string_fun3_info
    lea    si,string_fun3
    mov    cl,00h
    
    MOV    BH,0    	;空格标志
    MOV    DI,0    
func_3_store:    
    MOV    DL,0 
    MOV    DH,10
func_3_real_store:     
    get_char
    CMP    AL,0DH  	;判断是否按下回车键 
    JE     func_3_next_step
    CMP    AL,20H  	;判断是否按下空格键 
    JE     func_3_save_num  
    MOV    BH,0
    AND    AL,0FH
    MOV    BL,AL
    MOV    AL,DL
    MUL    DH
    ADD    AX,BX
    CMP    AH,0
    JNE    func_3_error_input
    MOV    DL,AL 
    JMP    func_3_real_store
func_3_error_input:
    disp_line string_fun3_error
    JMP    func_3_before_store
 
func_3_save_num:    
    CMP    BH,0
    JNZ    func_3_before_store
    MOV    [si],DL
    inc    si
    inc    cl 
func_3_before_store:    
    MOV    BH,1
    JMP    func_3_store
func_3_next_step:    
    CMP    BH,0
    JNZ    func_3_sort
    MOV    [si],DL
    inc    cl
    lea    di,string_fun3_count
    MOV    [di],cl
    
func_3_sort:
    
    lea    si,string_fun3_count
    mov    cl,[si]
    lea    si,string_fun3
for1:
    lea    di,string_fun3_count 
    mov    ch,cl
    mov    di,si
    inc    di
   
    
for2:
    mov    bl,[si]
    mov    bh,[di]
    cmp    bl,bh
    jbe    afterswap
    mov    [si],bh
    mov    [di],bl    
    
afterswap:
    dec    ch
    inc    di
    cmp    ch,1
    ja     for2
    
    inc    si
    dec    cl
    cmp    cl,1
    ja     for1
 
    
    
    
 
 
 
 
 
    
func_3_finish:
    lea    di,string_fun3_count
    MOV    cl,[di]    
    lea    di,string_fun3
    change_line
 
func_3_write:
    
    MOV    BH,[di]
    MOV    DL,BH
    AND    DL,0F0H
    MOV CL,4
    SHR    Dl,cl
    
    CMP    DL,0AH
    JGE    func_3_writechar1
    ADD    DL,30H
    JMP    func_3_writed1
func_3_writechar1:
    ADD    DL,37H    
    
func_3_writed1:
    MOV    AH,2
    INT    21H
    MOV    DL,BH
    AND    DL,00FH
    
    CMP    DL,0AH
    JGE    func_3_writechar2
    ADD    DL,30H
    JMP    func_3_writed2
func_3_writechar2:
    ADD    DL,37H     
      
func_3_writed2:     
    MOV    AH,2
    INT    21H
    
    MOV    DL,20h
    MOV    AH,2
    INT    21H    
    
    
    INC    di
    DEC    cl
    CMP    cl,0
    JNE    func_3_write
    
 
    
    change_line
    disp_line string_next_fun
    get_char
    cmp    al,020h
    jnz    do_fun3_again
    mov    ax,00h
    mov    si,ax
    mov    di,ax
    jmp    main_menu
    
do_fun3_again:    
    mov    ax,00h
    mov    si,ax
    mov    di,ax
    mov    ah,2
    mov    dl,0dh
    int    21h    
    jmp    func_3
 
SORT:    
        PUSH DI 
        DEC DI
        CMP DI,0
        JZ  DONE
        MOV AX,DI
        MOV CH,AL
N2:     MOV CL,CH
        LEA SI,string_fun3
        MOV BL,0    	;交换标志
N1:     MOV AL,[SI]
        CMP AL,[SI+1]
        JBE NOCHG
        XCHG AL,[SI+1]
        MOV [SI],AL
        MOV BL,1
NOCHG:  INC SI
        DEC CL
        JNZ N1
        CMP BL,0
        JZ  DONE
        DEC CH
        JNZ N2
DONE:  POP DI
        RET
 
;***************func_4***********************
func_4:
    mov    ah,2
    mov    dl,0dh
    int    21h
    lea    DX,string_doing_func4
    mov    ah,09h
    int    21h    
    mov    ah,2
    mov    dl,0dh
    int    21h    
    mov    ah,2
    mov    dl,0dh
    int    21h
    
    lea    DX,string_next_fun    
    mov    ah,09h
    int    21h
    mov    ah,1
    int    21h
    cmp    al,020h
    jnz    do_fun4_again
    mov    ax,00h
    mov    si,ax
    mov    di,ax
    jmp    main_menu
    
do_fun4_again:    
    mov    ax,00h
    mov    si,ax
    mov    di,ax
    mov    ah,2
    mov    dl,0dh
    int    21h    
    jmp    func_4
        
;***************func_5***********************
func_5:
 
    mov ah, 4ch
    int 21h
 
 
    
; return to operating system:
    RET
START   ENDP
 
;*******************************************
 
CSEG    ENDS 
 
        END    START    ; set entry point.
