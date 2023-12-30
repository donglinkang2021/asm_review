## 子程序基本知识

### 子程序定义

在汇编语言中用过程定义伪指令定义子程序。过程定义伪指令格式

```asm
过程名 PROC [NEAR/FAR] [USES 寄存器列表]
    过程体
    RET
过程名 ENDP
```

过程定义伪指令中的过程名是过程的标号，NEAR/FAR是过程的类型，USES寄存器列表是过程体中使用的寄存器，RET是过程返回指令，ENDP是过程结束伪指令。

要注意几点

- 寄存器的保存与恢复
  - 在子程序开头保存它要用到的寄存器内容，返回前再恢复它们
- 注意堆栈状态
  - 例如CALL调用类型和子程序定义类型的一致性，
  - PUSH和POP指令的匹配
  - 通过堆栈传递参数时子程序返回使用RET n指令等
  - 以确保堆栈平衡
- 子程序说明
  - 为便于引用，子程序应在开头对其功能、调用参数和返回参数等予以说明，
    - 例如参数的类型、格式及存放位置等

### 堆栈

<details>
<summary>1. 保护和恢复调用现场</summary>

```asm
push eax
push ebx
...
pop ebx
pop eax
```

相当于在过程名的那一行加上`USES eax, ebx, ...`，但是这样写更加灵活，可以在过程体中随时保存和恢复寄存器的值。

</details>

<details>
<summary>2. 用于变量之间的数据传递</summary>

```asm
; 交换两个变量的值
push VAR1
push VAR2
pop VAR1
pop VAR2
```

</details>

<details>
<summary>3. 用做临时的数据区</summary>

```asm
szStr BYTE 10 DUP(0)
mov eax, 8192

; 将eax中的内容转换为十进制字符串存放在szStr中
xor edx, edx
xor ecx, ecx
mov ebx, 10
mov edi, OFFSET szStr
L1:             ; store 2, 9, 1, 8 to stack
    div ebx
    push edx    ; edx:eax / 10 = eax ... edx
    inc ecx 
    xor edx, edx
    cmp eax, edx
    jnz L1
L2:             ; pop 8, 1, 9, 2 from stack and process
    pop eax
    add al, '0'
    mov [edi], al
    inc edi
    loop L2
    mov byte ptr [edi], 0
```

</details>

<details>
<summary>4. 子程序的调用和返回</summary>

1. 在调用子程序时，CALL指令自动在堆栈中保存其返回地址；
2. 从子程序返回时，RET指令从堆栈中取出返回地址。
3. 子程序中的局部变量也放在堆栈中。子程序执行过程中，这些局部变量是
可用的；
4. 主程序还可以将参数压入堆栈，子程序从堆栈中取出参数


</details>

### 子程序的返回地址

设计两个子程序：第1个子程序AddProc1使用ESI和EDI作为加数，做完加法后把和放在EAX中；第2个子程序AddProc2使用X和Y作为加数，做完加法后把和放在Z中。主程序先后调用两个子程序，最后将结果显示出来。

- 在AddProc2中用到了EAX，所以要先将EAX保存在堆栈中，返回时再恢复EAX的值。否则EAX中的值会被破坏。

```asm
.386
.model flat,stdcall
option casemap:none
includelib msvcrt.lib
printf PROTO C :dword,:vararg
.data
szFmt byte '%d + %d=%d', 0ah, 0 ;输出结果格式字符串
x dword ?
y dword ?
z dword ?
.code
AddProc1 proc       ;使用寄存器作为参数
    mov eax, esi    ;EAX=ESI + EDI
    add eax, edi
    ret
AddProc1 endp
AddProc2 proc       ;使用变量作为参数
    push eax        ;C = A + B
    mov eax, x
    add eax, y
    mov z, eax
    pop eax         ;恢复EAX的值
    ret
AddProc2 endp
start:
    mov esi, 10
    mov edi, 20     ;为子程序准备参数
    call AddProc1   ;调用子程序
    ;结果在EAX中
    
    mov x, 50
    mov y, 60       ;为子程序准备参数
    call AddProc2   ;调用子程序
    ;结果在Z中

    invoke printf, offset szFmt, esi, edi, eax ;显示第1次加法结果
    invoke printf, offset szFmt, x, y, z ;显示第2次加法结果
    ret
end start
```