## CPU工作模式

- 实模式
- 保护模式
  - 支持多任务和特权级；页式存储；段式存储
  - 特权0级最高 **OS** ，特权3级最低
- 虚拟8086模式

<details>
<summary>
CPU的3种运行模式及其切换
</summary>

```mermaid
graph LR
    blank[Reset复位] --> real_mode[实模式]
    real_mode[实模式] --> |LMSW指令、修改CR0| protect_mode[保护模式]
    protect_mode --> |Reset复位、修改CR0| real_mode
    protect_mode -->|IRETD指令、任务转换| virtual_8086_mode[虚拟8086模式]
    virtual_8086_mode -->|中断或异常| protect_mode
    virtual_8086_mode -->|Reset复位| real_mode
    
    style blank fill:none,stroke:none
```

通过修改CR0寄存器的PE位(位0)可以实现实模式和保护模式的切换。

</details>