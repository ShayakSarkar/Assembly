section .data
	times 512 input_buffer db 0x00		; whatever is going to be inputted is to be stored
section .text
	global _start

	_start:
		mov eax,3
		mov ebx,0
		mov ecx,input_buffer
		mov edx,512
		int 0x80

		mov ebx,input_buffer
		S_loop_label1:
			cmp ebx,0x00
			je S_break1 

			mov eax,byte [ebx]
			push eax
			inc ebx
			jmp S_loop_label1
		S_break1:

		mov ecx,1
		mov edi,0
		S_loop_label2:
			pop eax



