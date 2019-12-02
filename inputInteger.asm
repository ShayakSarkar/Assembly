section .data
	input_buffer times 512  db 0x00		; whatever is going to be inputted is to be stored
	msg db "h"
section .text
	global _start
	_printBuffer:	
		mov esi,input_buffer
		_loop:
			cmp byte [esi],0x00
			je _break
			mov eax,4
			mov ebx,1
			mov ecx,esi
			mov edx,1
			int 0x80
			
			inc esi
			jmp _loop
		_break:

		ret
	_start:
		; take the input which is supposed to be an integer
		;--------------------------------------------------
		
		mov eax,3
		mov ebx,0
		mov ecx,input_buffer
		mov edx,512
		int 0x80
		
		call _printBuffer
		
		mov eax,4
		mov ebx,1
		mov ecx,msg
		mov edx,1
		int 0x80

		;jmp $
		; push the digits into the stack so that 
		; they can be popped later on for ease of 
		; constructing the integer
		;----------------------------------------
		
		mov esi,0	; count the number of digits 
		mov ebx,input_buffer
		S_loop_label1:
			cmp byte [ebx],0x00
			je S_break1 
			mov eax,0	
			mov al,byte [ebx]
			push eax
			inc ebx
			inc esi
			jmp S_loop_label1
		S_break1:

		; making the integer from the popped integers in the stack
		;---------------------------------------------------------
		
		pop eax	  ; unknown bug
		dec esi   ; unknown bug

		mov ecx,1	; multiplies the individual digits with ecx to contruct the final integer
		mov edi,0	; stores the final integer	
		S_loop_label2:
			cmp esi,0	; if counter is zero all digits have been popped out of the stack
			je S_break1 
			pop eax
			sub eax,48
			mov edx,0
			mul ecx
			add edi,eax
			dec esi
			
			mov edx,0
			mov eax,ecx
			mov ebx,10
			mul ebx
			mov ecx,eax

			mov eax,edx


			jmp S_loop_label2
		S_break:
		
		mov eax,1
		mov ebx,0
		int 0x80





