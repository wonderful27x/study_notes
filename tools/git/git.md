## Learn git skills see [git book](https://book.git-scm.com/book/en/v2)

### git log 查看历史记录
* 显示某个提交范围内的简略统计信息，能够快速找出修改的文件  
`git log --stat --left-right --author wonderful 8b69304a662353abf3ad3a0a62c1940d89c7f6ac...5ddaef07263836dcee441053e2d2091d13d48fd3 > e:/tmp/git.log`
* 指定具体文件  
`git log --stat --left-right --author wonderful 8b69304a662353abf3ad3a0a62c1940d89c7f6ac...5ddaef07263836dcee441053e2d2091d13d48fd3 -- app/cgui/mcom/session_client.cpp`
* 指定具体文件夹  
`git log --stat --left-right --no-merges --author wonderful 8b69304a662353abf3ad3a0a62c1940d89c7f6ac...5ddaef07263836dcee441053e2d2091d13d48fd3 -- app/`

### 主题分支合入master分支需要引入的工作（指定具体文件）
* `git diff master...contrib -- app/src/git.md`

### git + vim 统计提交区间内修改的文件列表
* git log out to file: `git log --name-only --left-right --author wonderful 8b69304a662353abf3ad3a0a62c1940d89c7f6ac...5ddaef07263836dcee441053e2d2091d13d48fd3 > e:/tmp/git.log`
* open file: `vim e:/tmp/git.log`
* search mode: `/\v.+\.(cpp|h)$`
* grep: `:lvimgrep // %`
* copy the result to a new file: `yG` and `p`
* delete prefix: `qa0d/| q` and `:'<,'>normal @a`
* sort: `sort`
* uniq: `:%!uniq`
