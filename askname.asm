section .data
	question db "what is your name??",0x0a
	message1 db "your name is "
section .bss
	name RESB 10

section .text
	global _start

	_start: 
		mov eax,4
		mov ebx,1
		mov ecx,question
		mov edx,20
		int 0x80

		mov eax,3
		mov ebx,0
		mov ecx,name
		mov edx,10
		int 0x80 

		mov eax,4
		mov ebx,1
		mov ecx,name
		mov edx,10
		int 0x80

		mov eax,1
		mov ebx,0
		int 0x80

