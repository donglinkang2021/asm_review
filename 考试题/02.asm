; 最后一题答案
.386
.model flat,stdcall
option casemap:none;

includelib msvcrt.lib
printf PROTO C:ptr sbyte,:VARARG
scanf PROTO C:ptr sbyte,:VARARG

.DATA
szInput byte "请输入一个字符串", 0ah,0
szFormat byte "%s",0
szResult1 byte "大写字母个数为：%d",0ah,0
szResult2 byte "小写字母个数为：%d",0ah,0
szResult3 byte "数字个数为：%d",0ah,0
szResult4 byte "其他字符个数为：%d",0ah,0
buffer byte 128 dup(?)
bigletter dword 0
smallletter dword 0
number dword 0
other dword 0

.CODE

count PROC
	mov esi,offset buffer
L1:
	mov al,[esi]
	cmp al,0
	je L2
	cmp al,'A'
	jl L3
	cmp al,'Z'
	jg L3
	inc bigletter
	jmp L4
L3:
	cmp al,'a'
	jl L5
	cmp al,'z'
	jg L5
	inc smallletter
	jmp L4
L5:
	cmp al,'0'
	jl L6
	cmp al,'9'
	jg L6
	inc number
	jmp L4
L6:
	inc other
	jmp L4
L4:
	inc esi
	jmp L1
L2:
	ret
count ENDP

main:
    invoke printf, ADDR szInput
    invoke scanf, ADDR szFormat, ADDR buffer
    invoke count
	invoke printf, ADDR szResult1, bigletter
	invoke printf, ADDR szResult2, smallletter
	invoke printf, ADDR szResult3, number
	invoke printf, ADDR szResult4, other
    ret
end main