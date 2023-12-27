## 寄存器

### 通用寄存器

| 寄存器 | 常用功能 | 64位 | 32位 | 16位 | 8位高 | 8位低 |
| --- | --- | --- | --- | --- | --- | --- |
| EAX | 累加器，乘法、除法运算等指令的专用寄存器 | RAX | EAX | AX | AH | AL |
| EBX | 保存数据，基址寄存器 | RBX | EBX | BX | BH | BL |
| ECX | 保存数据，循环指令的计数器，80386以上CPU也可用于访问存储器的偏移地址 | RCX | ECX | CX | CH | CL |
| EDX | 保存数据，用于乘法和除法指令的高32位结果，80386以上CPU也可用于访问存储器的偏移地址 | RDX | EDX | DX | DH | DL |
| EDI | 目的变址寄存器，用于寻址串指令的**目的**操作数 | RDI | EDI | DI | - | - |
| ESI | 源变址寄存器，用于寻址串指令的**源**操作数 | RSI | ESI | SI | - | - |
| EBP | 保存访问存储单元时的偏移地址 | RBP | EBP | BP | - | - |
| ESP | 保存栈顶地址 | RSP | ESP | SP | - | - |

### 专用寄存器

1. RIP (64位) / EIP (32位) / IP (16位)
   - 指令指针寄存器，保存下一条指令的地址
   - 当微处理器为8086/8088，80286或者工作在实模式下时，这个寄存器取16位IP
   - 80386以及更高型号的微处理，工作于保护模式下时这个寄存器取32位EIP
2. RSP (64位) / ESP (32位) / SP (16位)
   - 堆栈指针，指向栈顶满单元。这个寄存器作为16
   - 位寄存器时使用SP；作为32位寄存器时，使用ESP

### 状态标志寄存器


| 标志位 | 英文全称 | 简单说明 | 作用 |
| --- | --- | --- | --- |
| CF | Carry Flag | 进位标志位 | 当结果的最高位（字节操作时的第7位或字操作时的第15位）产生一个进位或借位，CF＝1，否则CF＝0。在移位或循环移位指令中，会把操作数的最高位（左移时）或最低位（右移时）移入CF中 |
| PF | Parity Flag | 奇偶标志位 | Intel微处理器中采用奇校验，当执行结果的低8位中二进制形式1的个数为奇数时，PF为0；否则为1|
| AF | Auxiliary Carry Flag | 辅助进位标志位 | 在字节操作时若低半字节（一个字节的低4位）向高半字节有进位或借位；在字操作时若低位字节向高位字节有进位或借位，则AF＝1，否则AF＝0。这个标志用于十进制算术运算指令中，即通过二进制数运算调整为十进制数表示的结果 |
| ZF | Zero Flag | 零标志位 | 当执行结果为0时，ZF＝1，否则ZF＝0 |
| SF | Sign Flag | 符号标志位 | 它与运算结果的最高位相同。对字节操作（8位运算）来说，是结果的第7位；对字操作（16位运算）来说，是结果的第15位。当SF＝0时，结果为正数或0；当SF＝1时，结果为负数 |
| TF | Trap Enable Flag | 单步标志位 | 当TF=1时，CPU进入单步方式，在每条指令执行以后产生一个内部中断（单步中断）。当TF＝0时，CPU执行指令后不产生单步中断 |
| IF | Interrupt Enable Flag | 中断允许标志位 | 当IF=1时，允许CPU接收外部中断请求，否则屏蔽外部中断请求 |
| DF | Direction Flag | 方向标志位 | 在字符串操作指令中，当DF=0时，串操作为自动增址；当DF=1时，串操作为自动减址。STD指令置位DF，CLD指令清除DF |
| OF | Overflow Flag | 溢出标志位 | 有符号数运算时，当其运算结果超出了表达的范围时，OF=1，否则OF＝0 |


> 区分CF和OF：CF是**无符号数**的进位标志位，OF是**有符号数**的进位标志位。


<details>
<summary>
状态标志寄存器例子

```asm
    0101  0100  0011  1001
+   0100  0101  0110  1100
----------------------------
    1001  1001  1010  0011
```

求运算后的CF、PF、OF、AF、ZF、SF的值。
</summary>

| 标志位 | 值 | 说明 |
| --- | --- | --- |
| CF | 0 | 无符号数运算，没有进位 |
| PF | 1 | 执行结果的低8位中二进制形式1的个数为偶数，则奇校验位为1 |
| OF | 1 | 有符号数运算，发生溢出（两个正数相加变为负数） |
| AF | 1 | 低半字节（一个字节的低4位）向高半字节有进位 |
| ZF | 0 | 结果不为0 |
| SF | 1 | 结果为负数 |

</details>

### 段寄存器

- 16位微处理器4个16位段寄存器： CS, DS, SS, ES
- 32位和64位微处理器6个16位段寄存器：CS, DS, SS, ES, FS, GS
- 不同模式下的段寄存器含义
  - 在实模式和虚拟8086模式下，兼容16位CPU，
    - 段寄存器内保存的是<font color=red>20位段首址的高16位，段首址的低4位为0</font>
  - 在保护模式下，段寄存器中的16位内容是<font color=red>段选择符</font>
    - 用于在段描述符表(GDT或LDT)中查找段描述符(8个字节)，段描述符中包含段的基址和段的限长还有一些基本信息
    - 段基址+偏移量 = 线性地址

<details>
<summary>

| 寄存器 | 英文全称 | 简单说明 | 作用 |
| --- | --- | --- | --- |
| CS | Code Segment | 代码段寄存器 | 保存当前代码段的段选择符 |
</summary>

- 代码段是存放代码（程序，包括过程）的一段存储区。
- 在实地址方式下，定义了一段64KB存储区的起始地址。
- 在保护方式下，用来检索一个描述符，该描述符用来描述一个代码段的若干特性——起始地址、段限以及访问权等。
- 最大段限在8086及80286中为$2^{16}$=64KB，而在80386及其以上的32位微处理器中则为$2^{32}$=4GB。64位模式下，代码段寄存器仍用于平展模式，但用法不同。

</details>


<details>
<summary>

| 寄存器 | 英文全称 | 简单说明 | 作用 |
| --- | --- | --- | --- |
| DS | Data Segment | 数据段寄存器 | 保存当前数据段的段选择符 |
</summary>

- 数据段存放供程序使用的数据的一段存储区
- 数据段中的数据按其给定的偏移地址值offset（或称有效地址EA，Effective Address）来访问。
- 数据段的长度规定同代码段。
- 64位平展模式中不用。

</details>

<details>
<summary>

| 寄存器 | 英文全称 | 简单说明 | 作用 |
| --- | --- | --- | --- |
| SS | Stack Segment | 栈段寄存器 | 保存当前栈段的段选择符 |
</summary>

- 堆栈段是一段用作堆栈的存储区。
  - 栈是向低地址扩展的数据结构，是一种先进后出的数据结构。
  - 堆是向高地址扩展的数据结构，malloc申请的内存就是在堆上。
- 堆栈段现行的入口地址由堆栈指针RSP（或ESP、SP）决定。
- RBP（或EBP、SP）也可寻址堆栈段中的数据。
- ES：Extra Segment，附加段寄存器
  - 附加段是一段附加的数据段，通常供串操作类指令用于存放目的串数据。
- FS、GS
  - 80386以上的微处理器（含80386）有两个新增的附加的段存储区。Windows将这些段寄存器用于内部操作没有说明其使用方法。

</details>

--------

80386 以后新增的寄存器

### 控制寄存器

<table>
<tr>
    <td colspan="1" align=center><b> CRx </b></td>
    <td colspan="1" align=center><b> 31 </b></td>
    <td colspan="19" align=center><b> 30~12 </b></td>
    <td colspan="7" align=center><b> 11~5 </b></td>
    <td colspan="1" align=center><b> 4 </b></td>
    <td colspan="1" align=center><b> 3 </b></td>
    <td colspan="1" align=center><b> 2 </b></td>
    <td colspan="1" align=center><b> 1 </b></td>
    <td colspan="1" align=center><b> 0 </b></td>
</tr>
<tr>
    <td colspan="1" align=center> CR0 </td>
    <td colspan="1" align=center> PG </td>
    <td colspan="19" align=center> 000 0000 0000 0000 0000 </td>
    <td colspan="7" align=center> 0000 000 </td>
    <td colspan="1" align=center> ET </td>
    <td colspan="1" align=center> TS </td>
    <td colspan="1" align=center> EM </td>
    <td colspan="1" align=center> MP </td>
    <td colspan="1" align=center> PE </td>
</tr>
<tr>
    <td colspan="1" align=center> CR1 </td>
    <td colspan="32" align=center> 保留未用 </td>
</tr>
<tr>
    <td colspan="1" align=center> CR2 </td>
    <td colspan="32" align=center> 页故障线性地址 </td>
</tr>
<tr>
    <td colspan="1" align=center> CR3 </td>
    <td colspan="20" align=center> 页目录基址 </td>
    <td colspan="12" align=center> 0000 0000 0000 </td>
</tr>
</table>

<details>
<summary>
机器状态字的含义了解一下
</summary>

| 机器状态字 | 英文全称 | 含义 |
| --- | --- | --- |
| PE | Protection Mode Enable | 保护模式允许标志。=0为实模式，CPU reset（启动）时自动进入实模式；=1为保护模式。可以通过软件设置PE进入或退出保护模式 |
| MP | Monitor Coprocessor | 运算协处理器存在位。=1表示系统中有协处理器 |
| EM | Emulate Processor Extension | 仿真位。=1时，可以利用7号中断，用软件来仿真协处理器的功能；=0时用硬件控制浮点指令 |
| TS | Task Switched | 任务切换标志。=1时，表示CPU正在执行任务切换 |
| ET | Extension Type | 协处理器选择标志；80386以后的系统中ET位被置为1表示系统中存在协处理器 |
| PG | Paging Enable| 分页标志。=1时，存储器管理单元允许分页。=0时，分页功能被关闭，此时CR2和CR3寄存器无效 |
| CR2 | Page Fault Linear Address | 用于发生页异常时报告出错信息|
| CR3 | Page Descriptor Base Register | 它的高20位用于保存页目录表的起始物理地址的高20位 |

</details>

### 全局描述符表寄存器GDTR

- GDTR （Global Descriptor Table Register）为48位寄存器
- 高32位基址指出GDT在物理存储器中存放的**基地址**。
- 低16位限长+1 = 全局描述符表的字节大小
  - 低16位限长+1 / 8 = GDT中**描述符的个数**

<table>
<tr>
    <td colspan="1" align=center><b> GDTR </b></td>
    <td colspan="32" align=center><b> 47~16 </b></td>
    <td colspan="16" align=center><b> 15~0 </b></td>
</tr>
<tr>
    <td colspan="1" align=center> GDTR </td>
    <td colspan="32" align=center> GDTbase(基址) </td>
    <td colspan="16" align=center> limit(限长) </td>
</tr>
</table>

全局描述符表GDT

- 一种共享系统资源
- 通常包含操作系统所使用的**代码段**、**数据段**和**堆栈段**的描述符
- 也包含多种特殊描述符，如LDT描述符。该存储区域可以被所有任务访问，在任务切换时，并不切换GDT
- 每个GDT最多含有8192个描述符，每个描述符占8个字节，所以每个GDT最大容量为2^16 =64KB
  - 可以在内存任意位置

<details>
<summary>
例3-1 已知GDTR=<font color=red>0E003F00</font><font color=blue>03FF</font>H，则全局描述符表的基址是多少？这个全局描述符表有多大，里面有多少个描述符？
</summary>

- GDT的地址为0E003F00H，
- 长度为3FFH+1=400H。(即全局描述符表大小为400Byte)
- 可容纳400H/8=80H个段描述符

</details>


### 中断描述符表寄存器IDTR

- IDTR （Interrupt Descriptor Table Register）为48位寄存器
- 高32位基址指出IDT在物理存储器中存放的**基地址**。
- 低16位限长+1 = 中断描述符表的字节大小
  - 低16位限长+1 / 8 = IDT中**描述符的个数**

<table>
<tr>
    <td colspan="1" align=center><b> IDTR </b></td>
    <td colspan="32" align=center><b> 47~16 </b></td>
    <td colspan="16" align=center><b> 15~0 </b></td>
</tr>
<tr>
    <td colspan="1" align=center> IDTR </td>
    <td colspan="32" align=center> IDTbase(基址) </td>
    <td colspan="16" align=center> limit(限长) </td>
</tr>
</table>

中断描述符表IDT

-  IDT中保存的是中断门描述符。每个门描述符包含8字节，IDT最多包含256个门描述符，因为CPU最多支持256个中断 最大长度也就2^11 = 2KB
-  保护模式下的中断描述符表的功能，类似于实模式下的**中断向量表**。但**IDT的位置可变**，由相应的描述符说明，而实模式下的中断向量表的地址是固定的，必须在物理地址00000H处

<details>
<summary>
已知IDTR=<font color=red>0E003F400</font><font color=blue>07FF</font>H，求IDT的地址和长度。这个IDT中有多少个中断门描述符？
</summary>

- IDT的地址为0E003F400H，
- 长度为7FFH+1=800H。
- 其中可容纳800H/8=100H个中断门描述符。
</details>

<font color=red>注意：GDTR和IDTR的值必须在进入保护模式之前装入。在实模式下，可以执行LGDT和LIDT指令设置GDTR和IDTR</font>

### 局部描述符表寄存器LDTR

- LDT（Local Descriptor Table Register）定义的是某项任务用到的局部存储器地址空间。
- 多任务环境下由于每项任务都有自己的LDT（且每项任务最多只能有一个LDT），因此保护模式下可以有多个LDT。
- LDT由LDTR（局部描述符表寄存器）确定。LDTR为16位的选择符。

> 找到LDT流程是：先用GDTR找到内存中GDT的位置，接着用LDTR的索引在这个GDT中找到LDT描述符的位置，最后根据LDT描述符中的位置和限长信息找到内存中的LDT

<details>
<summary>
假定LDT的基址为00120000H，GDT基址为00100000H。如果装入CS寄存器的选择符为1007H，那么请求特权级是多少？段描述符地址是多少？描述符在GDT还是LDT里面获得？
</summary>
解答：
CS = <font color=red>0001 0000 0000 0</font><font color=green>1</font><font color=blue>11</font>B

- 请求特权级为3
- TI为<font color=green>1</font>表示在LDT中获得段描述符
- offest = <font color=red>0001 0000 0000 0</font>B x 8 = 1000H
- 段描述符的地址为 LDTbase + offest = 00121000H

</details>

### 任务寄存器

- 任务寄存器TR （Task Register），在保护模式的任务切换机制中使用，TR中内容为16位选择符。
- TR的作用是选中TSS描述符。每一个任务都有一个任务状态段TSS，由TSS描述符描述。从GDT中检索出TSS描述符后，微处理器自动将TSS描述符装入TSS Cache中。
- TR的初值由软件装入，当执行任务切换指令时TR的内容自动修改。

<details>
<summary>
例题 3‑ 3 假定全局描述符表的基址为00011000H，TR为2108H，问TSS描述符的起始范围是多少？
</summary>

解答：TSS起始地址=00011000H+2108H=00013108H由于描述符为**8字节**，故TSS终止位置为00013108H+7H=0001310FH
</details>

> 由TR取得TSS（也是一个描述符）的过程和获得LDT描述符的过程差不多
