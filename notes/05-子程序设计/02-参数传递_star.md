## 参数传递

可以通过给子程序传递参数使其更通用。常用的参数传递方法如下：

1. 通过寄存器传递;
2. 通过数据区的变量传递
3. 通过堆栈传递

### C语言函数的参数传递方式

在C/C++以及其他高级语言中，函数的参数是通过**堆栈**来传递的。C语言中的库函数，以及WindowsAPI等也都使用**堆栈**方式来传递参数。

C函数常见的有5种参数传递方式

| 调用规则 | 参数入栈顺序 | 参数出栈顺序 | 说明 |
| :---: | :---: | :---: | :---: |
| cdecl方式 | 从右至左 | 主程序 | 参数个数可动态变化 |
| stdcall方式 | 从右至左 | 子程序 | Windows API常使用 |
| fastcall方式 | 用ECX、EDX传递第1、2个参数，其余的参数同stdcall，从右至左 | 子程序 | 常用于内核程序 |
| this方式 | ECX等于this，从右至左 | 子程序 | C++成员函数使用 |
| naked方式 | 从右至左 | 子程序 | 自行编写进入/退出代码 |

举例

<details>
<summary>1. cdecl方式</summary>

```c
int subproc(int a, int b)
{
    return a-b;
}
int r,s;
int main( )
{
    r=subproc(30, 20);
    s=subproc(r, -1);
}
```

```asm
00401000 PUSH EBP
00401001 MOV EBP,ESP
00401003 MOV EAX,DWORD PTR [EBP+8]
00401006 SUB EAX,DWORD PTR [EBP+0CH]
00401009 POP EBP
0040100A RET
0040100B PUSH EBP
0040100C MOV EBP,ESP
0040100E PUSH 14H       ; 20
00401010 PUSH 1EH       ; 30
00401012 CALL 00401000
00401017 ADD ESP,8          ; two int parameters, so add 8
0040101A MOV [00405428],EAX ; r=subproc(30, 20);
0040101F PUSH 0FFFFFFFFH    ; -1
00401021 MOV EAX,[00405428]
00401026 PUSH EAX           ; r
00401027 CALL 00401000
0040102C ADD ESP,8
0040102F MOV [0040542C],EAX ; s=subproc(r, -1);
00401034 POP EBP
00401035 RET
```

</details>

<details>
<summary>2. stdcall方式</summary>

堆栈的平衡是由子程序来完成的，子程序使用`RET n`指令

Windows API采用的调用规则就是stdcall方式。
`WINBASEAPI int WINAPI lstrcmpA(LPCSTR lpStr1, LPCSTR lpStr2);`
其中的WINAPI定义为：
`#define WINAPI __stdcall`

将`subproc()`设置为使用`__stdcall`调用规则：
`int _stdcall subproc(int a, int b)`

</details>

<details>
<summary>3. fastcall方式与this方式</summary>

- fastcall方式
  - 这种方式和stdcall类似。区别是它使用ECX传递第1个参数，EDX传递第2个参数。其余的参数采用从右至左的顺序入栈，由子程序在返回时平衡堆栈。例如：

```c
int _fastcall addproc(int a, int b, int c, int d)
```

- this方式
  - 这种方式和stdcall类似，在C++类的成员函数中使用。它使用ECX传递this指针，即指向对象

</details>

<details>
<summary>4. naked方式</summary>

前面4种方式中，编译器自动为函数生成进入代码和退出代码。进入代码的形式为：

```asm
00401000 PUSH EBP
00401001 MOV EBP, ESP
```

退出代码的形式为：

```asm
00401009 POP EBP
0040100A RET 8
```

</details>

### 汇编语言子程序的参数传递方式

```asm
SubProc1 proc ;使用堆栈传递参数
    push ebp
    mov ebp,esp
    mov eax,dword ptr [ebp+8]   ;取出第1个参数
    sub eax,dword ptr [ebp+12]  ;取出第2个参数
    pop ebp
    ret
SubProc1 endp
SubProc2 proc ;使用堆栈传递参数
    push ebp
    mov ebp,esp
    mov eax,dword ptr [ebp+8]   ;取出第1个参数
    sub eax,dword ptr [ebp+12]  ;取出第2个参数
    pop ebp
    ret 8                       ;平衡主程序的堆栈，就不需要主程序再次平衡堆栈
SubProc2 endp
start:
    push 10                     ;第2个参数入栈
    push 20                     ;第1个参数入栈
    call SubProc1               ;调用子程序
    add esp, 8
    push 100                    ;第2个参数入栈
    push 200                    ;第1个参数入栈
    call SubProc2               ;调用子程序
    ret
end start
```

<details>
<summary>参数入栈</summary>

```txt
0012FFB0            |                |
                    ------------------
0012FFB4            |                |
                    ------------------
0012FFB8            |                |
                    ------------------
0012FFBC     ESP--->|   0000 0014    |
                    ------------------
0012FFC0            |   0000 000A    |
                    ------------------
0012FFC4            |                |
                    ------------------
```

</details>

<details>
<summary>返回地址入栈</summary>

```txt
0012FFB0            |                |
                    ------------------
0012FFB4            |                |
                    ------------------
0012FFB8     ESP--->|   0040 1021    |
                    ------------------
0012FFBC            |   0000 0014    |
                    ------------------
0012FFC0            |   0000 000A    |
                    ------------------
0012FFC4            |                |
                    ------------------
```

</details>

<details>
<summary>EBP入栈</summary>

```txt
0012FFB0            |                |
                    ------------------
0012FFB4     ESP--->|   0012 FFF0    |<---EBP
                    ------------------
0012FFB8            |   0040 1021    |
                    ------------------
0012FFBC            |   0000 0014    |
                    ------------------
0012FFC0            |   0000 000A    |
                    ------------------
0012FFC4            |                |
                    ------------------
```

</details>

### 带参数子程序的调用

```asm
SubProc1 proc C a:dword, b:dword        ; 使用C规则
    mov eax, a                          ; 取出第1个参数
    sub eax, b                          ; 取出第2个参数
    ret                                 ; 返回值=a-b
SubProc1 endp
SubProc2 proc stdcall a:dword, b:dword  ; 使用stdcall规则
    mov eax, a                          ; 取出第1个参数
    sub eax, b                          ; 取出第2个参数
    ret                                 ; 返回值=a-b
SubProc2 endp
start:
    invoke SubProc1, 20, 10
    invoke printf, offset szMsgOut, 20, 10, eax
    invoke SubProc2, 200, 100
    invoke printf, offset szMsgOut, 200, 100, eax
    ret
end start
```

### 子程序中的局部变量

LOCAL伪指令的格式为

```asm
LOCAL变量名1[重复数量][:类型], 变量名2[重复数量][:类型]…
```

LOCAL伪指令必须紧接在子程序定义的伪指令PROC之后

```asm
LOCAL TEMP[3]:DWORD
LOCAL TEMP1, TEMP2:DWORD
```

```asm
swap proc C a:ptr dword, b:ptr dword    ;使用堆栈传递参数
    local temp1,temp2:dword
    mov eax, a
    mov ecx, [eax]
    mov temp1, ecx                      ;temp1=*a
    mov ebx, b
    mov edx, [ebx]
    mov temp2, edx                      ;temp2=*b
    mov ecx, temp2
    mov eax, a
    mov [eax], ecx                      ;*a=temp2
    mov ebx, b
    mov edx, temp1
    mov [ebx], edx                      ;*b=temp1
    ret
swap endp
start proc
    invoke printf, offset szMsgOut, r, s
    invoke swap, offset r, offset s
    invoke printf, offset szMsgOut, r, s
    ret
start endp
end start
```
