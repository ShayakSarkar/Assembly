section .text
	global _start
	
	_printInteger:
		push 48+3
		push 48+2
		push 48+1
		
		mov esi,3	;esi is used as counter
		PI_loop_label1:
			cmp esi,0	;if counter is 0
			je PI_Break1
			dec esi
			mov eax,4
			mov ebx,1
			mov ecx,esp
			mov edx,1
			int 0x80
			pop eax
			jmp PI_loop_label1
		PI_Break1:
	
		ret
	_start:
		mov eax,12
		call _printInteger
		mov eax,1
		mov ebx,0
		int 0x80

		
