.386
.model flat,stdcall
option casemap:none
includelib msvcrt.lib
printf PROTO C:dword, :vararg
scanf PROTO C:dword, :vararg

.DATA
szInfo 	byte 	"请输入给定数0~15", 0ah,0
szFmt 	byte 	"%d",0
A 		dword 	?
B 		dword 	?
szRes 	byte 	"保存后的B值为%d",0ah,0
SQTAB 	dword 	0,1,4,9,16,25,36,49,64,81,100,121,144,169,196,225
szERR 	byte 	"输入错误",0ah,0

.CODE
main:
    invoke printf, offset szInfo
    invoke scanf, offset szFmt, offset A
	mov eax, A
	cmp eax, 0
	jl ERR
	cmp eax, 15
	jg ERR
	mov esi, offset SQTAB
	lea esi, [esi+eax*4]
	mov ebx, [esi]
	mov B, ebx
	invoke printf, offset szRes, B
	jmp Return
ERR:
	invoke printf, offset szERR
Return:
    ret
end main