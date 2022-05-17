set nocompatible 
colorscheme ron
syntax on
set history=1000
set undofile
set undodir=~/.vim/undo/,.
set backup
set backupdir=~/.vim/backup/,.
set number
set ruler
set tabstop=4
set shiftround
set autoindent
set smartindent
set shiftwidth=4
set showcmd
set wildmenu
set hls
set backspace=indent,eol,start
set rnu

"Navigation

nn s <Nop>
nn ss :ls<CR>:b<space>
nn sn :bn<CR>
nn sp :bp<CR>

"Macros

"smart printf
let @p = '0iprintf(">%<\n", €ýaA);€ýahhbvey2F"pa : €ýaf%a'

"Autocmd for tags files

autocmd BufEnter *.h,*.c :silent !ctags -R
autocmd BufWritePost *.h,*.c :silent !ctags -R
autocmd VimLeave *.h,*.c :silent !rm tags

" Usefull
" arg/argadd/argdo %s/patern/replace/ge
" vimgrep pattern ## (## replaced by arglist)
" **/*.c list every c file in dir and subdir
