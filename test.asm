section .data
	buffer db 0x00	; used to store the character required for printing
	endl db 0x15
section .text
	global _start

	_endl:
		mov eax,1
		mov ebx,1
		mov ecx,endl
		mov edx,1
		int 0x80
		
		ret

	_printInteger:		; prints and integer value in eax
		
		mov esi,0	; stores the counter value
		
		PI_loop_label1:
			cmp eax,0
			je PI_break1

			mov edx,0
			mov ebx,10	; divisor
			div ebx		; eax / ebx
			add edx,48	; edx has the remainder
			push edx	; edx is pushed into stack so that it can be printed in revers later

			inc esi
			jmp PI_loop_label1
		PI_break1:
		
		PI_loop_label2:
			cmp esi,0
			je PI_break

			pop eax
			mov [buffer],eax	; this is the digit to be printed buffer is passed to ecx
			
			mov eax,4
			mov ebx,1
			mov ecx,buffer
			mov edx,1
			int 0x80
			dec esi
			jmp PI_loop_label2
		
		PI_break:
		
		ret
	
	_start:
		mov eax,123
		call _printInteger
		call _endl

		mov eax,1
		mov ebx,0
		int 0x80

