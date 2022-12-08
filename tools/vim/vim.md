## Learn vim skills see [Vim 实用技巧](), [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/), [vim config](https://github.com/wonderful27x/vimcofig)

### Delete repeated line
* search mode: `/\v.+\.(cpp|h)$`
* grep: `:lvimgrep // %`
* copy the result to a new file: `yG` and `p`
* delete prefix: `qa0d/| q` and `:'<,'>normal @a`
* sort: `sort`
* uniq: `:%!uniq`
