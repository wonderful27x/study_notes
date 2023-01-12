## Learn vim skills see [Vim 实用技巧](), [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/), [vim config](https://github.com/wonderful27x/vimcofig)

[TOC]

### skill-1
**Delete repeated line**
* search mode: `/\v.+\.(cpp|h)$`
* copy content
    * use grep:
        * grep: `:lvimgrep // %`
        * copy the result to a new file: `yG` and `p`
        * delete prefix: `qa0d/| q` and `:'<,'>normal @a`
    * use global:
        * clean: `qaq`
        * global: `g//yank A`
        * yank: `put a`
* sort: `sort`
* uniq: `:%!uniq`

### skill-2
**Data process**
* Collect useful data from log, change date time to ms, data calculate [see vimrc # register macro record](https://github.com/wonderful27x/vimcofig/blob/main/.vimrc)
* 从log中提取有用数据，绘制折线统计图、时分秒转换为毫秒ms、数据累加、相邻数据差值计算 [see vimrc # register macro record](https://github.com/wonderful27x/vimcofig/blob/main/.vimrc)

### skill-3
**以列表的每一行内容作为参数依次执行外部命令，将输出保存下来**
* shell read
    * 提取列表, example see [git skill-3](../git/git.md#skill-3)
    * 将作为参数的每行内容拼接到一行并存入寄存器z, `gg100@x` see [vimrc-register @x](https://github.com/wonderful27x/vimcofig/blob/main/.vimrc) 
    * 将外部命令`git diff cloud-v43-sp2-dev...cloud-v43-sp2-dev-sync -- `存入寄存器c
    * 调整光标位置`G`
    * 执行execute: `:execute "read !" . @c . @z`
> **原理**：read会将外部命令的输出插入当前光标下，如果外部命令不支持多参数同时传递，这种方法就不行
* shell filter
    * 提取列表, example see [git skill-3](../git/git.md#skill-3)
    * 将每一行扩充为完整的命令，在每行行首添加`git diff master...branch -- `
    * 运行命令: `:.,$!sh`
> **原理**：`.,$`范围的每行内容会在shell中执行并将输出替换每行的内容
* global ...
* 宏 ...
