global start

section .text
bits 32
start:
    ; move page table address to cr3
    mov eax, p4_table
    mov cr3, eax

    ; enable PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; set the long mode bit
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; enable paging
    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 16
    mov cr0, eax
    ; mov word [0xb8000], 0x0248 ; H
    ; mov word [0xb8002], 0x0265 ; e
    ; mov word [0xb8004], 0x026c ; l
    ; mov word [0xb8006], 0x026c ; l
    ; mov word [0xb8008], 0x026f ; o
    ; mov word [0xb800a], 0x022c ; ,
    ; mov word [0xb800c], 0x0220 ;
    ; mov word [0xb800e], 0x0277 ; w
    ; mov word [0xb8010], 0x026f ; o
    ; mov word [0xb8012], 0x0272 ; r
    ; mov word [0xb8014], 0x026c ; l
    ; mov word [0xb8016], 0x0264 ; d
    ; mov word [0xb8018], 0x0221 ; !
		; hlt

section .bss

align 4096

p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096

secton .rodata
gdt64:
		dq 0
		dq (1<<44) | (1<<47) | (1<<41) | (1<<43) | (1<<53)
		dq (1<<44) | (1<<47) | (1<<41)

.pointer:
		dw .pointer - gdt64 - 1
		dq gdt64
		lgdt [gdt64.pointer]
