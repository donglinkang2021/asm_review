## 选择符

<table>
<tr>
    <td colspan="1" align=center><b> 😎 </b></td>
    <td colspan="1" align=center><b> 15 </b></td>
    <td colspan="1" align=center><b> 14 </b></td>
    <td colspan="1" align=center><b> 13 </b></td>
    <td colspan="1" align=center><b> 12 </b></td>
    <td colspan="1" align=center><b> 11 </b></td>
    <td colspan="1" align=center><b> 10 </b></td>
    <td colspan="1" align=center><b> 9 </b></td>
    <td colspan="1" align=center><b> 8 </b></td>
    <td colspan="1" align=center><b> 7 </b></td>
    <td colspan="1" align=center><b> 6 </b></td>
    <td colspan="1" align=center><b> 5 </b></td>
    <td colspan="1" align=center><b> 4 </b></td>
    <td colspan="1" align=center><b> 3 </b></td>
    <td colspan="1" align=center><b> 2 </b></td>
    <td colspan="1" align=center><b> 1 </b></td>
    <td colspan="1" align=center><b> 0 </b></td>
</tr>
<tr>
    <td colspan="1" align=center><b>  选择符 </b></td>
    <td colspan="13" align=center><b> Index </b></td>
    <td colspan="1" align=center><b> TI </b></td>
    <td colspan="2" align=center><b> RPL </b></td>
</tr>
</table>

- **RPL**（Requestor Privilege Level）： 请求特权级，2位二进制数字，范围为0～3。00代表特权级0，01代表特权级1，10代表特权级2，11代表特权级3。
- 请求特权级是将要访问的段的特权级。
- **TI**（Table Indicator）：表指示符。为0时，从GDT中选择描述符；为1时，从LDT中选择描述符。
- **Index**：索引。指出要访问描述符在段描述符表中的顺序号，Index占13位。因此，顺序号的范围是0～8191。每个段描述符表（GDT或LDT）中最多有$8192=2^{13}$个描述符
  - 获得描述符offset的方法是 offset = 索引 × 8 (一个描述符八个字节)，刚好就是在**最后三位补零**即可
- CS,DS 这些段寄存器中存放的就是选择符

<details>
<summary>
已知DS=0023H，问该数据段的请求特权级和索引值。
</summary>
解答

- DS = <font color=red>0000 0000 0010 0</font><font color=green>0</font><font color=blue>11</font>b，
- 故：Index=0 0000 0000 0100b=4，TI=0，RPL=11b=3。
- 因此请求特权级为3，索引值为4
</details>