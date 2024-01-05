## 浮点运算

### 浮点数的表述与存储

```asm
a real8 3.2 ;定义64位浮点数变量a，初始化为3.2
b real10 100.25e9 ;定义80位浮点数变量b，初始化为100.25e9
c qword 3. ;定义64位浮点数变量c，初始化为3.0
d qword 3 ;定义64位整型变量d，初始化为3
```

<font color=red>`qword`既可以定义整数也可以定义浮点数</font>

> real8是占8个字节

| 格式 | 说明 |
| --- | --- |
| 单精度 32位 | 1位符号位，8位阶码，23位为有效数字的小数部分。 |
| 双精度 64位 | 1位符号位，11位阶码，52位为有效数字的小数部分。 |
| 扩展精度 80位 | 1位符号位，15位阶码，1位为整数部分，63位为小数部分。 |


<details>
<summary>举例：01000010 11101110 00011011 10100110B单精度浮点数</summary>

<table>
    <tr>
        <th colspan="1" align=center> </th>
        <th colspan="1" align=center>
            符号位
        </th>
        <th colspan="8" align=center>
            符号位
        </th>
        <th colspan="23" align=center>
            尾数
        </th>
    </tr>
    <tr>
        <th colspan="1" align=center>
            32位单精度浮点数
        </th>
        <th colspan="1" align=center>
            0
        </th>
        <th colspan="8" align=center>
            10000101
        </th>
        <th colspan="23" align=center>
            11011100001101110100110
        </th>
    </tr>
</table>

- <font color=red>0</font><font color=green>1000010 1</font><font color=blue>1101110 00011011 10100110</font>B
- <font color=red>符号位</font><font color=green>阶码</font><font color=blue>尾数</font>
- <font color=red>符号位</font>为<font color=red>0</font>，为正数；
- <font color=green>指数</font>为<font color=green>10000101</font>（133），减去127得6；
- <font color=blue>尾数</font>加上1后为1.<font color=blue>11011100001101110100110</font>，十进制表示为：1.86021876
- <font color=blue>尾数</font>乘以2的6次方后可得结果为：119.05400（单精度7～8位有效数字）

</details>

### 浮点数寄存器

<table>
    <tr>
        <th colspan="1" align=center>
            地址
        </th>
        <th colspan="3" align=center>
            FPU寄存器栈
        </th>
        <th colspan="2" align=center> </th>
        <th colspan="3" align=center>
            标志寄存器
        </th>
    </tr>
    <tr>
        <th colspan="1" align=center>
            7
        </th>
        <td colspan="3" align=center>
            FPR7
        </td>
        <td colspan="2" align=center> </td>
        <td colspan="3" align=center>
            tag7
        </td>
    </tr>
    <tr>
        <th colspan="1" align=center>
            6
        </th>
        <td colspan="3" align=center>
            FPR6
        </td>
        <td colspan="2" align=center> </td>
        <td colspan="3" align=center>
            tag6
        </td>
    </tr>
    <tr>
        <th colspan="1" align=center>
            5
        </th>
        <td colspan="3" align=center>
            FPR5
        </td>
        <td colspan="2" align=center> </td>
        <td colspan="3" align=center>
            tag5
        </td>
    </tr>
    <tr>
        <th colspan="1" align=center>
            4
        </th>
        <td colspan="3" align=center>
            FPR4
        </td>
        <td colspan="2" align=center> </td>
        <td colspan="3" align=center>
            tag4
        </td>
    </tr>
    <tr>
        <th colspan="1" align=center>
            3
        </th>
        <td colspan="3" align=center>
            FPR3
        </td>
        <td colspan="2" align=center> </td>
        <td colspan="3" align=center>
            tag3
        </td>
    </tr>
    <tr>
        <th colspan="1" align=center>
            2
        </th>
        <td colspan="3" align=center>
            FPR2
        </td>
        <td colspan="2" align=center> </td>
        <td colspan="3" align=center>
            tag2
        </td>
    </tr>
    <tr>
        <th colspan="1" align=center>
            1
        </th>
        <td colspan="3" align=center>
            FPR1
        </td>
        <td colspan="2" align=center> </td>
        <td colspan="3" align=center>
            tag1
        </td>
    </tr>
    <tr>
        <th colspan="1" align=center>
            0
        </th>
        <td colspan="3" align=center>
            FPR0
        </td>
        <td colspan="2" align=center> </td>
        <td colspan="3" align=center>
            tag0
        </td>
    </tr>
    
</table>


<details>
<summary>例子：计算表达式f = a + b * m的值</summary>

```asm
;PROG0409.asm
.586
.model flat, stdcall
option casemap:none
includelib msvcrt.lib
printf PROTO C :ptr sbyte, :VARARG
.data
    szMsg byte "%f", 0ah, 0
    a real8 3.2
    b real8 2.6
    m real8 7.1
    f real8 ?
.code
start:
    finit               ;finit为FPU栈寄存器的初始化
    fld m               ;fld为浮点值入栈
    fld b
    fmul st(0),st(1)    ;fmul为浮点数相乘，结果保存在目标操作数中
    fld a
    fadd st(0),st(1)    ;fmul为浮点数相加，结果保存在目标操作数中
    fst f               ;fst将栈顶数据保存到内存单元
    invoke printf, offset szMsg, f
    ret
end start
```
</details>

<details>
<summary>例子：输入圆的半径，计算圆面积。</summary>

```asm
; PROG0410.asm例4.37 输入圆的半径，计算圆面积。
.data
    szMsg1 byte "%lf", 0
    szMsg2 byte "%lf", 0ah, 0
    r real8 ?       ;圆半径
    S real8 ?       ;圆面积
.code
start:
    finit           ;finit为FPU栈寄存器的初始化
    invoke scanf, offset szMsg1, offset r
    fld r
    fld r
    fmulp st(1), st(0)
    fldpi
    fmulp st(1), st(0)
    fst S           ;fst将栈顶数据保存到内存单元
    invoke printf, offset szMsg2, S
    ret
end start
```
</details>

