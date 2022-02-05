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

"Navigation

nn ss :ls<CR>:b<space>
nn sn :bn<CR>
nn sp :bp<CR>

"Macros

let @p = 'Iprintf("A : >%d<\n", €ýaF";lylA€ýapA);€ýa'
