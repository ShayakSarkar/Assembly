section .data
	msg db "hello word",0x0a
section .text
	global _start
		
	printMessage:
		dec ecx
		push ecx 
		mov eax,4
		mov ebx,1
		mov ecx,msg
		mov edx,11
		int 0x80
		pop ecx
		cmp ecx,0
		jge printMessage
		ret
	_start:         
			mov ecx,5
			call printMessage	
			mov eax,1
			mov ebx,0
			int 0x80

