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
**在连续的一系列参数下运行同一条命令**
**此技巧在git的差异检出和复杂的合并当中非常有用**
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
* shell write
    * 提取列表, example see [git skill-3](../git/git.md#skill-3)
    * 将需要执行的连续的参数行扩充为完整的命令，在每行行首添加`git checkout branchX -- `
    * 选择需要执行的范围
    * 运行命令: `:'<,'>write !sh`
> **原理**：在shell中执行选择范围内的每行内容
    
* global ...
* 宏 ...

### skill-4
**对多个文件执行相同的操作**  
* 使用参数列表args
    * 填充参数列表
        * 使用`args a.txt b.txt`手动添加每一个文件
        * 使用`args *.*`添加工作目录下所有文件
        * 使用`args **/*.cpp`添加工作目录及其所有子目录后缀为`.cpp`的文件
        * 使用`args **/*.*`添加工作目录及其所有子目录下的所有文件
        * 使用`args 'cat .chapter'`添加`.chapter`文件清单列出的所有文件
    * 启用 'hidden' 设置，解决文件未保存切换到下一个文件时提示警告的问题
        * `set hidden`
    * 执行相同令
        * 直接执行：`argdo %s/OnDeliveryFrame/OnFrameIncoming/g`
        * 运行脚本：`argdo source batch.vim`
        * 执行宏：`argdo normal @a`, 注意先放弃录制宏时的修改`e!`
    * 保存
        * `argdo write`
> **原理**：参数列表默认会记录vim启动时传递的参数，但是接下来我们可以对它进行随意修改  
`args`打印当前参数列表内容，`args {argslist}`填充参数列表, {arglist} 可以包括文件名、通配符，甚至是一条 shell 命令的输
出结果  
接下来使用argdo在列表中的每一个缓冲区执行同一条ex命令

* 使用quickfix window
    * 构建查找模式
        * `/ConnectToDelivery`
    * 使用vimgrep查找包含关键字的文件
        * `vimgrep // **/*.h **/*.cpp`
    * 启用 'hidden' 设置，解决文件未保存切换到下一个文件时提示警告的问题
        * `set hidden`
    * 使用cfdo命令在quickfix window列表每个文件执行操作
        * `cfdo %s//ConnectToDeliverySink/g`
    * 保存
        * `cfdo update`
