section .data
	input_buf times 512 db 0x00	; Temporary storage for input data
	output_buf times 512 db 0x00	; Temporary storage for data to be printed on the screen
	character db "x"
	null db "0"
	endl db 0x0a

section .text
	global _start	

	_inputString:		; inputs a string and stores it in input_buf
		mov eax,3	
		mov ebx,0
		mov ecx,input_buf
		mov edx,512
		int 0x80
		ret
	
	_showInputBuffer:
		mov edi,0
		SIB_loop_label1:
			cmp edi,512
			je SIB_break1
			cmp byte[input_buf + edi],0x00
			je printNull
			mov eax,4
			mov ebx,1
			mov ecx,character
			int 0x80
			inc edi
			jmp SIB_loop_label1
			printNull:
				mov eax,4
				mov ebx,1
				mov ecx,null
				mov edx,1
				inc edi
				int 0x80
				jmp SIB_loop_label1

		SIB_break1:
		
		mov eax,4
		mov ebx,1
		mov ecx,endl
		mov edx,1
		int 0x80

		ret

	_clearInputBuffer:	; re-initialises input buffer with 0x00
		mov ecx,0
		CIB_loop_label1: 
			cmp ecx,512	; check if buffer size has exceeded
			je CIB_break1
			cmp byte [input_buf + ecx],0x00		; check if the pointer points to an already cleared region of the buffer
			je CIB_break1
			mov [input_buf + ecx],byte 0x00		; clear the byte
			inc ecx
			jmp CIB_loop_label1
		CIB_break1:
		ret
	
	_clearOutputBuffer:	; re-initialises output buffer with 0x00
		mov ecx,0
		COB_loop_label1:
			cmp ecx,512	; check if buffer size has exceeded
			je COB_break1
			cmp byte [output_buf + ecx],0x00	; check if the pointer points to an already cleared region of the buffer
			jmp COB_break1
			mov [output_buf + ecx],byte 0x00	; clear the byte
			inc ecx
			jmp COB_loop_label1
		COB_break1:
		ret


	_outputString:	; outputs a string present in output_buf
		mov esi,0
		OS_loop_label1:
			cmp edi,512
			je OS_break1
			cmp byte [output_buf + edi],0x00	; check if end of string
			je OS_break1
			mov eax,4
			mov ebx,1
			mov ecx,output_buf
			add ecx,edi
			mov edx,1
			int 0x80
			inc edi
			jmp OS_loop_label1
		OS_break1:
		ret

	_populateOutputBufferWithString:		; populates the output_buf with the string present at eax
		mov esi,eax	       ; free up eax for future system calls. esi now has the location of the string buffer to be printed
		POBWS_loop_label1:
			cmp byte [esi],0x00	; check if end of string
			je POBWS_break1
			mov eax,4
			mov ebx,1
			mov ecx,esi
			mov edx,1
			int 0x80
			inc esi
			jmp POBWS_loop_label1
		POBWS_break1:

		ret
	
	_printInteger:		; prints the integer present in eax
		mov ecx,0	; counter to count the number of digits in the number
		PI_loop_label1:
			cmp eax,0
			je PI_break1
			mov edx,0
			mov ebx,10
			div ebx
			push edx	; push the last digit of the number in eax into the stack
			inc ecx
			jmp PI_loop_label1
		PI_break1:

		;stack now has the digits in reverse order
		
		mov edx,0	; counter to count the number of digits pushed into the output buffer
		PI_loop_label2:
			cmp edx,ecx
			je PI_break2
			pop eax
			add eax,48
			mov [output_buf + edx],al
			inc edx
			jmp PI_loop_label2
		PI_break2:

		call _clearOutputBuffer
		call _outputString
		ret
	
	_inputInteger:		; Takes an integer input and stores it in eax
		
		call _clearInputBuffer
		call _showInputBuffer
		call _inputString	; The integer string is now present in the input buffer

		mov ecx,0	; offset from the starting of the input buffer input_buf
		mov esi,1	; multiplier	
		mov edi,0	; initialisation...has the final integer value 

		II_loop_label1:
			cmp byte [input_buf + ecx],0x00
			je II_break1
			mov eax,0
			mov al,byte [input_buf + ecx]
			sub eax,48
			mul esi
			add edi,eax
			mov eax,esi
			mov ebx,10
			mul ebx
			mov esi,eax
			inc ecx
			jmp II_loop_label1
		II_break1:
		mov eax,edi

		ret

	_start:

		call _clearInputBuffer
		call _inputString
		;call _showInputBuffer
		mov eax,input_buf
		call _populateOutputBufferWithString
		call _outputString
		call _clearOutputBuffer

		call _clearInputBuffer
		call _inputString
		;call _showInputBuffer
		mov eax,input_buf
		call _populateOutputBufferWithString
		call _outputString
		call _clearOutputBuffer

		mov eax,1
		mov ebx,0
		int 0x80
