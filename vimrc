""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc of Fwolf
"
" @package		fwolfrc
" @copyright	Copyright © 2012, Fwolf
" @author		Fwolf <fwolf.aide+fwolfrc@gmail.com>
" @license		http://opensource.org/licenses/mit-license MIT
" @since		2012-09-24
" @link			https://github.com/amix/vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" 这个设置将避免vim以和vi高度兼容的方式工作。这个设置需要在每个vimrc文件的开始。从而影响接下来的很多设置。
set nocompatible


" 启动自动缩进(ai)
set autoindent

" Auto reload file when it's modified outside
set autoread

" 叫vim使用在深色背景dark上看起来比较舒服的颜色显示
" 但如果是在图形界面下，还是用浅色背景light更舒服
set background=dark

" 这个将影响退格键的工作，具体情况非常复杂，可以参照:help 'bs'。bs=backspace
set backspace=2

" 使vim在tab处，插入tab符而不是一串空格
set noexpandtab

" 关闭文件备份的功能
set nobackup

" 按照 C 语言的语法，自动地调整缩进的长度
set cindent

"设置屏幕的行数
set columns=80

" 文件编码
set fileencodings=utf-bom,utf-8,gb2312,default

" 允许折叠
" http://scmbob.org/vim_fdm.html
"set foldenable
"set foldmethod=indent	" 按缩进折叠
"set foldmethod=manual	" 手动折叠
"set foldmethod=marker	" 按标记折叠，默认为 {{{ 和 }}}, 会自动添加

" Sets how many lines of history VIM has to remember
set history=1000

" 显示行号
"set number

" 使得vim在右下角显示当前行列数
set ruler

" 光标移动到 buffer 底部和顶部时保持 N 行距里
set scrolloff=3

" 根据代码结构自动缩进的空格数
set shiftwidth=4

" tab键跳过的空格数
set tabstop=4

" 设置了在窗口右侧何处开始换行
"set wrapmargin=8


syntax on

:set hlsearch
:set showmode



" 禁止自动改变当前Vim窗口的大小
let Tlist_Inc_Winwidth=0
" 把方法列表放在屏幕的右侧
let Tlist_Use_Right_Window=1
" 让当前不被编辑的文件的方法列表自动折叠起来， 这样可以节约一些屏幕空间
let Tlist_File_Fold_Auto_Close=1



" 删除多层嵌套的邮件引文，顺便删除上面 sender 那行
" 删除 google groups 的脚注，连同其上下的两个空行
map <F9> :g/^>\s*>/d<CR> kdd :g/> --\~--/,/> -\~/d<CR> k2dd :wq

" Vimtips: 设置F12键清除所有内容
map <F12> 1GdG:wq

" F10去掉自动缩进功能，F11重新打开之，方便粘贴内容
map <F11> :set noautoindent<CR>:set nocindent<CR>
map <F10> :set autoindent<CR>:set cindent<CR>



" Easy comment
" http://www.vim.org/scripts/script.php?script_id=2082
:runtime comments.vim



" http://plog.longwin.com.tw/my_note-unix/2008/10/30/vim-tips-open-file-line-2008
" 每次開啟檔案, 都回復到上次的行數
" Or press `"
if has("autocmd")
	autocmd BufRead *.txt set tw=78
	autocmd BufReadPost *
	\ if line("'\"") > 0 && line ("'\"") <= line("$") |
	\ 	exe "normal g'\"" |
	\ endif
endif



" http://kezeodsnx.pixnet.net/blog/post/25222797-vim自動去除行末空白及最後的空白行
" Remove trailing whitespace when writing a buffer, but not for diff files.
" From: Vigil
function RemoveTrailingWhitespace()
    if &ft != "diff"
        let b:curcol = col(".")
        let b:curline = line(".")
        silent! %s/\s\+$//

		" Original: remove \n at EOF
        "silent! %s/\(\s*\n\)\+\%$//
		" Changed: left 1 \n if more than 1 at EOF
        silent! %s/\(\s*\n\)\+\%$/\r/

        call cursor(b:curline, b:curcol)
    endif
endfunction
if has("autocmd")
	autocmd BufWritePre * call RemoveTrailingWhitespace()
endif



" 用浅色高亮当前行
if has("autocmd")
	autocmd InsertLeave * se nocursorline
	autocmd InsertEnter * se cursorline
endif
