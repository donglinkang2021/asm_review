## 分支与循环程序设计

<!-- 1．掌握IF_THEN_ELSE程序设计
2．掌握CASE结构程序设计
3．掌握循环程序基本结构及其程序设计方法
4．掌握统计、查找、插入、删除、排序等程序设计。 -->

### IF_THEN_ELSE程序设计


<details>
<summary>例5.1 求带符号数A和B的较大值MAXAB = MAX（A, B）。</summary>

```asm
;PROG0501
MOV EAX, A
CMP EAX, B
JGE AIsLarger
MOV EAX, B
AIsLarger:
MOV MAXAB, EAX
```

</details>

<details>
<summary>例5.3 求带符号数X的符号，如果X>=0，SIGNX置1，否则置为-1。</summary>

```asm
;PROG0503
X SDWORD -45
SIGNX SDWORD ?
MOV SIGNX, 0
CMP X, 0
JGE XisPostive
MOV SIGNX, -1
JMP HERE
XisPostive:
MOV SIGNX, 1
HERE:
```
</details>

<details>
<summary>在升序数组中找一个数，二分查找</summary>

```asm
.386
.model flat,stdcall
option casemap:none
includelib 	msvcrt.lib
printf       	PROTO C :dword,:vararg
.data
dArray      byte  	15, 27, 39, 40, 68, 71, 82, 100, 200, 230
Items       equ  	($-dArray)   	; 数组中元素的个数
Element     byte  	14          	; 在数组中查找的数字
Index       dword	?           	; 在数组中的序号
Count   	dword 	?               ; 查找的次数
szFmt		byte 	'Index=%d Count=%d Element=%d', 0ah, 0 ; 格式字符串
szErrMsg	byte	'Not found, Count=%d Element=%d', 0ah, 0 
.code
start:
    mov	Index, -1               ; 赋初值, 假设找不到
    mov Count, 0           	    ; 赋初值, 查找次数为0
    mov esi, 0             	    ; esi表示查找范围的下界
    mov edi, Items-1      	    ; edi表示查找范围的上界
    mov al, Element        	    ; EAX是要在数组中查找的数字
Compare:            
    cmp esi, edi           	    ; 下界是否超过上界
    ja  notfound            	; 如果下界超过上界, 未找到
    mov ebx, esi    	        ; 取下界和上界的中点
    add ebx, edi    		
    shr	ebx, 1         	        ; EBX=(ESI+EDI)/2
    inc Count               	; 查找次数加1
    cmp	al, dArray[EBX]    	    ; 与中点上的元素比较
    jz  Found          	        ; 相等, 查找结束
    ja  MoveLow       	        ; 较大, 移动下界
    mov	edi, ebx       	        ; 较小, 移动上界
    dec	edi                 	; ESI元素已比较过, 不再比较
    jmp	Compare        	        ; 范围缩小后, 继续查找
MoveLow:    
    mov	esi, ebx          	    ; 较大, 移动下界
    inc	esi       		        ; ESI元素已比较过, 不再比较
    jmp	Compare       	        ; 范围缩小后, 继续查找
Found:            
    mov	Index, ebx    	        ; 找到, EBX是下标
    xor	eax,  eax
    mov	al, dArray[esi]
    invoke printf, offset szFmt, Index, Count, eax
    ret
NotFound:            
    xor	eax,  eax
    mov	al, Element	
    invoke	printf, offset szErrMsg, Count, eax 
    ret
end start
```
</details>


</details>

### SWITCH_CASE程序设计

<details>
<summary>switch_case</summary>

```asm
;PROG0507
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf         PROTO C:ptr sbyte,:vararg 	; 用法：printf(str);
scanf         PROTO C:ptr sbyte,:vararg 	; 用法：scanf("%d", &op);
.data
Msg1	db '1——create',0ah         	; 菜单字符串
    	db '2——update',0ah
    	db '3——delete',0ah
     	db '4——print',0ah
    	db '5——quit',0ah,0
Msg2  	db 'input select:',0ah,0     	; 提示字符串
Fmt2	db '%d',0                       ; scanf的格式字符串
op   	dd ?                           	; scanf结果(用户输入的整数)
MsgErr	db 'Error!',0ah,0             	; 输入错误后的显示的字符串
MsgC 	db 'Create a File',0ah,0ah,0    ; 选择菜单1后的显示的字符串
MsgU	db 'Update a File',0ah,0ah,0   	; 选择菜单2后的显示的字符串
MsgD	db 'Delete a File',0ah,0ah,0   	; 选择菜单3后的显示的字符串
MsgP 	db 'Print a File',0ah,0ah,0     ; 选择菜单4后的显示的字符串
MsgQ	db 'Quit',0ah,0              	; 选择菜单5后的显示的字符串
JmpTab	dd offset CR              	; 跳转表，保存5个标号
    	dd offset UP
    	dd offset DE
     	dd offset PR
     	dd offset QU
.code
start:  
  	invoke  printf,offset Msg1     	; 显示菜单      
Rdkb:
    invoke  printf,offset Msg2    		; 显示提示 
   	invoke  scanf,offset Fmt2,offset op	; 接收用户的输入
	cmp 	op,1               		; 与1比较
	jb 	Beep                 		; 输入的数字比1小，不合法
	cmp	op,5                		; 与5比较 
	ja  	Beep                  	; 输入的数字比5大，不合法
	mov 	ebx,op
	dec 	ebx                   	; 转换为跳转表的索引
	mov  	eax, JmpTab[ebx*4]   	; 得到表项地址
	jmp 	eax						; 按表项地址转到对应的标号处
	jmp 	JmpTab[ebx*4]          	; 可以用这一指令替换上面两条
Beep:
	invoke	printf,offset MsgErr     	; 提示输入错误
	jmp	Rdkb
CR:
	invoke	printf,offset MsgC     	; 显示 Create a File
	jmp	start          				; 回到主菜单，继续运行
UP:                               
	invoke	printf,offset MsgU     	; 显示 Update a File
	jmp	start
DE:     
	invoke	printf,offset MsgD  	; 显示 Delete a File
	jmp	start
PR:     
	invoke	printf,offset MsgP   	; 显示 Print a File
	jmp	start
QU:     
	invoke	printf,offset MsgQ     	; 显示 Quit
	ret                             ; 返回系统
end	start

```

</details>

### 循环程序设计

<details>
<summary>例5.10 计算n的阶乘。</summary>

```asm
.386
.model flat,stdcall
option casemap:none
includelib msvcrt.lib
printf PROTO C :dword,:vararg
.data
Fact dword ?
N equ 6
szFmt byte 'factorial(%d)=%d', 0ah, 0   ;输出结果格式字符串
.code
start:
mov ecx, N                              ;循环初值
mov eax, 1                              ;Fact初值
e10:
imul eax, ecx                           ;Fact=Fact*ECX
loop e10                                ;循环N次
mov Fact, eax                           ;保存结果
invoke printf, offset szFmt, N, Fact    ;打印结果
ret
end start
```
</details>

### 多重循环程序设计 （排序）

<details>
<summary>冒泡排序</summary>

```asm
.386
.model flat,stdcall
option casemap:none
includelib	msvcrt.lib
printf    	PROTO C	:dword,:vararg
.data
dArray  	dword 	20, 15, 70, 30, 32, 89, 12  		; 定义一个待排序的数组
ITEMS     	equ  	($-dArray)/4           				; 计算数组中元素的个数
szFmt     	byte 	'dArray[%d]=%d', 0ah, 0				; 定义输出结果的格式字符串
.code
start:
	mov 	ecx, ITEMS-1  								; 将数组长度减一的值放入ecx，作为外层循环的计数器
i10:            
	xor  	esi, esi  									; 将esi清零，作为内层循环的计数器
i20:            
	mov  	eax, dArray[esi*4]  						; 将数组的当前元素放入eax
	mov  	ebx, dArray[esi*4+4]  						; 将数组的下一个元素放入ebx
	cmp  	eax, ebx  									; 比较两个元素的大小
	jl   	i30  										; 如果当前元素小于下一个元素，跳过交换步骤
	mov  	dArray[esi*4], ebx  						; 否则，交换两个元素的位置
	mov 	dArray[esi*4+4], eax
i30:            
	inc  	esi  										; 内层循环计数器加一
	cmp 	esi, ecx  									; 比较内层循环计数器和外层循环计数器
	jb	i20  											; 如果内层循环还没有结束，跳回i20
	loop 	i10  										; 外层循环计数器减一，如果还没有结束，跳回i10
	xor 	edi, edi  									; 将edi清零，作为打印数组的循环计数器
i40:            
	invoke	printf, offset szFmt, edi, dArray[edi*4]  	; 打印数组的当前元素
	inc   	edi  										; 打印数组的循环计数器加一
	cmp  	edi, ITEMS  								; 比较打印数组的循环计数器和数组长度
	jb   	i40  										; 如果还没有打印完所有元素，跳回i40
	ret  												; 返回
end       	start  										; 程序结束

```
