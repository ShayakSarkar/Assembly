section .bss
	digit resb 2   ; will be used for a single digit
	integer resb 11  ; since we have decided integer size to be 4 B

section .data
	msg db "Shayak Is My Name And Playing Football Is What I Like",0x0 
	endl db 0x0a

section .text
	global _start
	
	_printMessage:   ;we shall assume that esi has the address of source
		PM_loop_label1: 
			cmp [esi],byte 0
			je PMbreak1
			mov eax,4
			mov ebx,1
			mov ecx,esi
			mov edx,1
			int 0x80
			inc esi
			jmp PM_loop_label1
		PMbreak1:	

		mov eax,4
		mov ebx,1
		mov ecx,endl
		mov edx,1
		int 0x80

		ret
	
	_printInteger:	; assumes that eax has the integer to be printed
		mov ecx,0  ;keeps a track of number of digits in the integer
		PI_loop_label1:
			cmp eax,0
			je PI_break1
			mov ebx,10
			mov edx,0
			div ebx
			push edx
			inc ecx
			jmp PI_loop_label1
		PI_break1:
		
		PI_loop_label2:
			cmp ecx,0
			je PI_break2
			pop eax
			push ecx
			call _printDigit
			pop ecx
			dec ecx
			jmp PI_loop_label2
			
		PI_break2:
		pop eax
		call _printDigit 
		ret
	_exit:
		mov eax,1
		mov ebx,0
		int 0x80
		ret
	
	_printDigit:	;we assume that the integer to be printed is in eax
		add eax,48
		push eax
		mov eax,4
		mov ebx,1
		mov ecx,esp
		mov edx,1
		int 0x80

		mov eax,4
		mov ebx,1
		mov ecx,endl
		mov edx,1
		int 0x80

		pop eax	   ; cleaning up the stack before the return statement

		ret

	_start:
		mov esi,msg
		call _printMessage
		mov eax,12345
		call _printInteger
