## C语言程序的反汇编

通过逆向分析将反汇编程序写成高级语言如C语言等代码格式

<details>
<summary>C语言代码

```C
1:  #include "stdio.h"
2:  int main( )
3:  {
4:      return 0;
5:  }
```

</summary>

<details>
<summary>汇编代码

```asm
00401020 55                 push ebp
00401021 8B EC              mov ebp,esp
00401023 83 EC 40           sub esp,40h
00401026 53                 push ebx
00401027 56                 push esi
00401028 57                 push edi
00401029 8D 7D C0           lea edi,[ebp-40h]
0040102C B9 10 00 00 00     mov ecx,10h
00401031 B8 CC CC CC CC     mov eax,0CCCCCCCCh
00401036 F3 AB              rep stos dword ptr [edi];以上为栈初始化过程。
00401038 33 C0              xor eax,eax; 返回值0保存在eax中。
0040103A 5F                 pop edi
0040103B 5E                 pop esi
0040103C 5B                 pop ebx
0040103D 8B E5              mov esp,ebp
0040103F 5D                 pop ebp;以上为栈初恢复过程。
00401040 C3                 ret
```

</summary>

| 局部变量存储空间 | 
| :-------------: |
| edi             |
| esi             |
| ebx             |
| cccc cccc      |
|  ...           |
| cccc cccc      |
| ebp            |

</details>
</details>


<details>
<summary>选择结构

```c
1:  int i;
2:  if(i>=0)
3:      printf("i is nonnegative!");
4:  else
5:      printf("i is negative!");
```

</summary>

```asm
00401049 83 7D FC 00            cmp dword ptr [ebp-4],0
0040104D7C 0F                   jl main+3Eh (0040105e)
0040104F 68 84 0F 42 00         push offset string "i is nonnegative!" (00420f84)
00401054 E8 87 00 00 00         call printf (004010e0)
00401059 83 C4 04               add esp,4
0040105CEB 0D                   jmp main+4Bh (0040106b)
0040105E 68 74 0F 42 00         push offset string "i is negative!" (00420f74)
00401063 E8 78 00 00 00         call printf (004010e0)
00401068 83 C4 04               add esp,4
```

</details>

<details>
<summary>循环结构

```c
1:  int i;
2:  for(i=1;i<=10;i++)
3:  ;
```

</summary>

```asm
00401038 C7 45 FC 01 00 00 00   mov dword ptr [ebp-4],1 ;局部变量i保存在栈中，通过[ebp-4]的方式访问。
0040103F EB 09                  jmp main+2Ah (0040104a)
00401041 8B 45 FC               mov eax,dword ptr [ebp-4]
00401044 83 C0 01               add eax,1
00401047 89 45 FC               mov dword ptr [ebp-4],eax
0040104A 83 7D FC 0A            cmp dword ptr [ebp-4],0Ah
0040104E 7F 02                  jg main+32h (00401052)
00401050 EB EF                  jmp main+21h (00401041)
```

</details>

<details>
<summary>指针

```c
1:  #include "stdio.h"
2:  int main( )
3:  {
4:      int *p,a;
5:      a=10;
6:      p=&a;
7:  }
```
</summary>

反汇编码如下所示。
```asm
00401028 C7 45 F8 0A 00 00 00   mov dword ptr [ebp-8],0Ah ; a=10，a为局部变量，通过[ebp-n]的方式访问。
0040102F 8D 45 F8               lea eax,[ebp-8]
00401032 89 45 FC               mov dword ptr [ebp-4],eax ; p=&a，p为局部变量，p中保存着a的地址。
```

</details>

<details>
<summary>函数

```c
1:  #include "stdio.h"
2:  int subproc(int a, int b)
3:  {
4:      return a*b;
5:  }
6:  int main( )
7:  {
8:      int r,s;
9:      r=subproc(10, 8);
10:     s=subproc(r, -1);
11:     printf("r=%d,s=%d",r,s);
12:     return 0;
13: }
```

</summary>

```asm
;子程序subproc的反汇编码如下所示。
………………………………栈初始化（略）………………………………
00401028 8B 45 08           mov eax,dword ptr [ebp+8]
0040102B 0F AF 45 0C        imul eax,dword ptr [ebp+0Ch] ;eax = a*b;返回值保存在eax中
………………………………栈的恢复（略）………………………………
00401035 C3 ret

;主程序main反汇编码如下所示。
00401005 E9 66 A4 00 00     jmp main (0040b470)
0040100A E9 01 00 00 00     jmp subproc (00401010)
………………………………栈初始化（略）………………………………
0040B488 6A 08              push 8
0040B48A 6A 0A              push 0Ah
0040B48C E8 79 5B FF FF     call @ILT+5(_subproc) (0040100a)
0040B491 83 C4 08           add esp,8
;第一次函数调用
0040B494 89 45 FC           mov dword ptr [ebp-4],eax
0040B497 6A FF              push 0FFh
0040B499 8B 45 FC           mov eax,dword ptr [ebp-4]
0040B49C 50                 push eax
0040B49D E8 68 5B FF FF     call @ILT+5(_subproc) (0040100a)
0040B4A2 83 C4 08           add esp,8
;第二次函数调用
0040B4A5 89 45 F8           mov dword ptr [ebp-8],eax
0040B4A8 8B 4D F8           mov ecx,dword ptr [ebp-8]
0040B4AB 51                 push ecx
0040B4AC 8B 55 FC           mov edx,dword ptr [ebp-4]
0040B4AF 52                 push edx
0040B4B0 68 50 FE 41 00     push offset string "r=%d,s=%d"(0041fe50)
0040B4B5 E8 76 02 00 00     call printf (0040b730)
0040B4BA 83 C4 0C add esp,0Ch
;输出结果
```

</details>