## 数据寻址方式

指令的构成

<table>
    <tr>
        <td colspan="1" align=center>
            操作码
        </td>
        <td colspan="1" align=center>
            操作数
        </td>
    </tr>
</table>

- format: `MOV 目标,源`
- function: `目标 <- 源`
- 目标和源是操作数域，各自可以有不同的寻址方式

当访内操作类型允许指定段寄存器时，可以使用**段超越前缀**指定，为了明确指出本条指令要寻址的内存单元在哪个段，如`MOV AX,ES:VER`

- 寻址方式的对象可以是寄存器、立即数、内存单元；

<details>
<summary>立即寻址方式

| 寻址方式 | 例子 |
| --- | --- |
| 立即寻址方式 | MOV AX, <font color=red>1234H</font> |

</summary>

- `立即数`  的寻址方式是立即寻址方式；

</details>

<details>
<summary>寄存器寻址方式

| 寻址方式 | 例子 |
| --- | --- |
| 寄存器寻址方式 | MOV <font color=red>AX</font>, 1234H |

</summary>

- `寄存器`  的寻址方式是寄存器寻址方式；
  - 若指令中使用的是`BX,SI,DI,EAX,EBX,ECX,EDX,ESI,EDI`
    - 即它们默认与DS段寄存器配合
  - 若使用的是`BP,EBP,ESP`
    - 则缺省情况默认与SS段寄存器配合

</details>

<details>
<summary>直接寻址方式

| 寻址方式 | 例子 |
| --- | --- |
| 直接寻址方式 | MOV AX, <font color=red>[1234H]</font> |

</summary>

- `[立即数]`或`内存单元`的寻址方式是直接寻址方式，此时的立即数就是一个有效地址；
  - 比如`MOV VAR, 1234H`，就是将1234H送到VAR所在的内存单元中；
  - 普通变量缺省情况是存放在DS所指向的数据段，
    - 即`MOV VAR, 1234H`等效于`MOV DS:[offset VAR], 1234H`，物理地址为`DS:offset VAR`；
    - 但允许使用段超越前缀指定为其它段。

</details>

<details>
<summary>寄存器间接寻址方式

| 寻址方式 | 例子 |
| --- | --- |
| 寄存器间接寻址方式 | MOV AX, <font color=red>[BX]</font> |

</summary>

- `[寄存器]`的寻址方式是寄存器间接寻址方式，此时的寄存器中存放的是一个地址；

</details>

<details>
<summary>寄存器相对寻址方式

| 寻址方式 | 例子 |
| --- | --- |
| 寄存器相对寻址方式 | MOV AX, <font color=red>8[BX]</font> |

</summary>

- `[寄存器+立即数]`或`立即数[寄存器]`的寻址方式是寄存器相对寻址方式，此时的寄存器中存放的是一个地址，立即数是一个位移量disp；
  - 寄存器可以是基址寄存器BX、BP，也可以是变址寄存器SI、DI；
  - 若指令中使用的是通用寄存器
    - 即它们默认与DS段寄存器配合
  - 若使用的是`BP,EBP,ESP`
    - 则缺省情况默认与SS段寄存器配合
 
</details>

<details>
<summary>基址变址寻址方式

| 寻址方式 | 例子 |
| --- | --- |
| 基址变址寻址方式 | MOV AX, <font color=red>[BX][SI]</font> |

</summary>

- `[基址寄存器+变址寄存器]`或`[基址寄存器][变址寄存器]`的寻址方式是基址变址寻址方式，此时的两个寄存器中存放的是一个地址和一个偏移量；
  - 变址寄存器不可以是ESP；

</details>

<details>
<summary>相对基址变址寻址方式

| 寻址方式 | 例子 |
| --- | --- |
| 相对基址变址寻址方式 | MOV AX, <font color=red>ARRY[BX][SI]</font> |

</summary>

- `[基址寄存器+变址寄存器+立即数]`或`立即数[基址寄存器][变址寄存器]`的寻址方式是相对基址变址寻址方式，此时的两个寄存器中存放的是一个地址和一个偏移量，立即数是一个位移量；

</details>

<details>
<summary>比例变址寻址方式

| 寻址方式 | 例子 |
| --- | --- |
| 比例变址寻址方式 | MOV EAX, <font color=red>ES:ARRY[4*BX]</font> |

</summary>

- `[基址寄存器+变址寄存器*比例因子+立即数]`或`立即数[基址寄存器][变址寄存器*比例因子]`的寻址方式是比例变址寻址方式，比例因子是一个常数。

</details>
