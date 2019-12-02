section .text
	global _start
	
	_add:	;(int number1,int number2)
		mov eax,[esi-4]
		mov ebx,[esi-8]
		ret
	_exit:	
		mov eax,1
		mov ebx,0
		int 0x80
		ret
	_start:
		push dword 1123
		push dword 123
		call _add
		call _exit
