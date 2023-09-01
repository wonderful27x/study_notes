## Learn git skills see [git book](https://book.git-scm.com/book/en/v2)

[TOC]

### skill-0
**git三棵树**
* **HEAD**
    * 当前分支引用的指针，该分支最后一次提交的快照，下一次提交的父节点
    * `git clone`克隆或`git checkout`切换分支，将HEAD指向新的分支引用，并将索引填充为该次提交的快照，然后将索引的内容复制到工作区
* **index**
    * 索引或缓存区，预期的下一次提交
    * `git commit`, 判断预期的下一次提交是否与上一次提交相同，提交后写入历史记录
* **Working Directory**
    * 工作目录或工作区，实际可编辑的文件，提交到暂存区之前的修改
    * `git add`将工作区的内容复制到缓存区

### skill-1
**git log 查看历史记录**
* 显示某个提交范围内的简略统计信息，能够快速找出修改的文件  
`git log --stat --left-right --author wonderful 8b69304a662353abf3ad3a0a62c1940d89c7f6ac...5ddaef07263836dcee441053e2d2091d13d48fd3 > e:/tmp/git.log`
* 指定具体文件  
`git log --stat --left-right --author wonderful 8b69304a662353abf3ad3a0a62c1940d89c7f6ac...5ddaef07263836dcee441053e2d2091d13d48fd3 -- app/cgui/mcom/session_client.cpp`
* 指定具体文件夹  
`git log --stat --left-right --no-merges --author wonderful 8b69304a662353abf3ad3a0a62c1940d89c7f6ac...5ddaef07263836dcee441053e2d2091d13d48fd3 -- app/`

> 注意：--left-right 用于指示log属于哪个分支，一般配合`branchA...branchB`, 上面基于同一个分支的commit区间使用没有意义

### skill-2
**合并的一般流程**
* `git merge-base master contrib` 查看两个分支的父节点
* `git log --oneline` && `git rebase -i HEAD~x` 知道了父节点，接下来可以整理提交历史，然后再合并
* `git diff master...contrib (-- app/src/git.md)` 查看主题分支合入master分支需要引入的工作（指定具体文件）
* `git checkout master` && `git merge contrib` 最后合并

### skill-3
**git + vim 统计提交区间内修改的文件列表**
* git log out to file: `git log --name-only --left-right --author wonderful 8b69304a662353abf3ad3a0a62c1940d89c7f6ac...5ddaef07263836dcee441053e2d2091d13d48fd3 > e:/tmp/git.log`
* open file: `vim e:/tmp/git.log`
* search mode: `/\v.+\.(cpp|h)$`
* filter the file list:
    * 方式一：grep
        * grep: `:lvimgrep // %`
        * copy the result to a new file: `yG` and `p`
        * delete prefix: `qa0d/| q` and `:'<,'>normal @a`
    * 方式二：global
        * clean: `qbq`
        * global: `:g//yank B`
        * yank: `:put b`
* sort: `sort`
* uniq: `:%!uniq`
* delete we dont want:
    * search mode: `/\/app\/cgui`
    * delete: `:g//d`

### skill-4
**将一个分支的特定几个文件手动合并到另一个分支**
**将一个分支的文件拷贝到另一个分支目录**
* checkout the branch witch you want to merge to
    * `git checkout master`
* copy the files from the branch witch you want to merge from
    * `git show branchX:src/media.cpp > src/media.merge.cpp`
* merge them in hands
    * `vimdiff src/media/merge.cpp src/media.cpp`
* add the changed files and commit
    * `git add src/media.cpp`
    * `git commit`
* remove the temporary files
    * `git clean -f`

> `git show branch:path/filename > path/fileanme.copy` 可以将一个分支的文件copy到另一个分支目录  
`git checkout branch -- path/filename` 则会覆盖当前分支的文件

### ~~skill-5~~
**~~将一个分支的特定几个文件自动合并到另一个分支（行不通，因为下面的方法只会快进，无法制造冲突）~~**
* make forking to avoid fast-forward
    * `git checkout master` 
    * `git checkout -b master-fork`
    * edit a file and include a little changes but make no influence
        * `vim src/media.cpp`
        * `Go<Esc>`、`:wq`
    * `git add src/media.cpp`
    * `git commit -m "make forking to avoid fast-forward only for next merge"`
* checkout a temporary branch from the one witch you want to merge to
    * `git checkout master`
    * `git checkout -b tmp`
* checkout the files from the branch witch you want to merge from, it will covers the files in current branch
    * `git checkout branchX -- src/media.cpp`
* commit the changes
    * `git add src/media.cpp`
    * `git commit`
* merge the temporary branch to your target
    * `git checkout master-fork`
    * `git merge tmp`

> 与上面的手动合并相比更加智能，并且能生成真正的合并记录，但是却没有手动合并控制精细，因为合并的特定文件有可能包含我们不想引入的差异却没有冲突，其实这种情况也很少发生，想象一下，一个cpp文件被两次修改，除了在文件末尾追加貌似都会产生冲突，还有一种比较常见的情况就是快进不会导致冲突，然而我们上面的操作避免了快进。

### skill-6
**将一个分支的特定几个文件自动合并到另一个分支，更好的方案**
* checkout to the branch witch you want to merge to
    * `git checkout master`
* merge the files from the branch witch you want to merge from
    * `git checkout --patch branchX -- src/media.cpp`
    * select `y`,`n` or `e` to apply or edit the changes
    * `git add src/media.cpp`
    * `git commit`
> 关键点：  
`git checkout branchX -- src/abc.cpp`使用branchX分支的指定文件覆盖当前分支的文件  
`git checkout --patch branchX -- src/xyz.cpp`将branchX分支的指定文件合入当前分支的文件，并以交互式决定每处引入的差异

### skill-7
**查看一个合并提交引入的内容**
* 我们到底希望查看什么？？？先看看我们如何合并的
    * 合并并解决冲突
    * 运行`git diff`查看我们修改了什么东西
    * 确认无误后commit
* 查看合并提交引入了什么，显然我们希望查看的是上述中`git diff`的内容
    * 对合并提交运行`git show`命令
    * 对合并提交运行`git log -p --cc`，默认不显示合并补丁需要`--cc`参数
    * 对合并提交运行`git log --stat --cc`，查看统计信息得到修改的文件列表

### skill-8
**`git show`命令**
* 查看标签和与之对应的提交信息
    * `git show tag-v1.0`
* 查看任意分支某个特定提交信息（通过SHA-1）
    * `git show 1c002d...`
* 查看当前分支最新的一个提交信息，包括merge
    * `git show`
* 查看任意分支最新的一个提交信息，包括merge
    * `git show branch-name`
* 查看某个合并的父提交
    * 第一个父提交，即合并时所在的分支
        * `git show d921970^1`
    * 第二个父提交，即合并的分支
        * `git show d921970^2`
* 检出冲突的拷贝
    * `git show :1:hello.rb > hello.common.rb`
    * `git show :2:hello.rb > hello.ours.rb`
    * `git show :3:hello.rb > hello.theirs.rb`
    > :1-common -> 共同祖先版本   
:2-ours -> 合并时所在的分支  
:3-theirs -> 需要合入的分支

### skill-9
**差异检出和复杂的合并，see [vim-skill-3](../vim/vim.md#skill-3)**

### skill-10
**修改旧的提交，甚至是第一个提交**
* `git rebase -i  --root` and mark `edit`
* `vim xxx` change the commit
* `git add xxx` stage the change
* `git commit --amend` commit the change for the target commit
* `git mergetool` deal the conflict
* `git rebase --continue` finish

### skill-11
**放弃修改(整个工作区或缓存区)**  
**修改提交(已经提交的历史)**  
有的时候修改了很多文件，想丢弃掉，使用`git reset`比`git restore`更好  
或有的时候希望修改已经提交的历史记录
* **`git reset`命令执行的三个基本步骤**
    * 第一步，移动HEAD
        * `git reset --soft HEAD~`(HEAD的父节点)，将该分支的HEAD指针指向上一个提交, 使用`--soft`参数不会改变索引和工作目录, 这时可以修改并重新提交。
    * 第二步，更新索引
        * `git reset --mixed HEAD~`, 如果使用了`--mixed`参数，这也是`git reset HEAD~`的默认行为，接下来会用HEAD指向的当前快照的内容来更新索引，这时只有工作区的内容是不变的，也可以修改重新提交, 这相当于回滚到了所有`git add`和`git commit`的命令执行之前。
    * 第三步，更新工作目录
        * `git reset --hard HEAD~`, 如果使用了`--hard`参数，则在最后将索引的内容更新到工作目录, 所以这也是最危险的一个命令
    
