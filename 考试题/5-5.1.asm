.386
.model flat,stdcall
option casemap:none;

includelib msvcrt.lib
printf PROTO C:ptr sbyte,:VARARG;
scanf PROTO C:ptr sbyte,:VARARG;

.DATA
szInfo byte "请输入一系列小写字母", 0ah,0
szFmt byte "%s",0
szRes byte "输出的大写字母为%s",0ah,0
buffer byte 128 dup(?)
.CODE

main:
    invoke printf, offset szInfo
    invoke scanf, offset szFmt, offset buffer
    
	; 将小写字母转化成大写字母显示出来
	mov esi, offset buffer
	L1:
		mov al, [esi]
		cmp al, 0
		je LRet
		cmp al, 'a'
		jl Next
		cmp al, 'z'
		jg Next
		sub al, 20H
		mov [esi], al
	Next:
		inc esi
		jmp L1
	LRet:
	; 显示结果
	invoke printf, offset szRes, offset buffer
    ret
end main