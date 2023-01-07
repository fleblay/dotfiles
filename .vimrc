set nocompatible
set background=dark
colorscheme gruvbox
filetype plugin indent on "set on filetype detection
syntax on
set history=1000
set undofile
set undodir=~/.vim/undo/,.
set backup
set backupdir=~/.vim/backup/,.
set number
set ruler
set shiftround "round indent to multiple of shiftwidth
set autoindent
set smartindent
set shiftwidth=4 "number of spaces to used for each step of autoindent
set tabstop=4 "number of spaces a <TAB> in the file counts for
set noexpandtab "do not expand tab when indenting with > or <
set showcmd
set wildmenu
set hlsearch "highlight previous search pattern
set incsearch "show what is already matched when typing search pattern
set backspace=indent,eol,start "allows to backspace over autoindent, line breaks and start of insert
set hidden "to allow to change buffer without having to save changes
set relativenumber
set ignorecase "ignore case while searching
set smartcase "overrides ignorecase if search patterns contains upper case char
set wrapmargin=3 "wrap text if 3 char away from right margin
set textwidth=100 "wrap text if longer than 120 char
set foldcolumn=1 "adds a column to far left to show fold info
set foldmethod=syntax
set winwidth=100 "minimal size for current window. Resize at expand of other windows
set laststatus=2 "always display status bar
set confirm "Ask to save files instead of failing a command due to unsaved changes
set cmdheight=2 "Bigger command height to avoid "Press Enter...

"Preparatory Work
"mkdir -p ~/.vim/undo ~/.vim/backup ~/.vim/pack/default/start
"git clone https://github.com/morhetz/gruvbox.git ~/.vim/pack/default/start/gruvbox

"Navigation windows
nnoremap <Space> <C-W>

"Disable hls until next search
nnoremap <C-L> :nohl<CR><C-L>

"Find and grep setup
set path=. "find path
set shell=/bin/bash\ -O\ globstar

"add path location for find util
"au FileType h,c,hpp,cpp,tpp,make setl path+=$PWD/** -> to fix
au FileType h,c,hpp,cpp,tpp,make setl path+=$PWD/inc,$PWD/src
"add all files in order to user grep ##
if v:version > 801
	au FileType h,c if !&diff | argadd! $PWD/inc*/**/*.h $PWD/s*rc*/**/*.c | argdedupe | endif
	au FileType hpp,cpp,tpp if !&diff | argadd! $PWD/inc*/**/*.?pp $PWD/s*rc*/**/*.cpp | argdedupe | endif
else
	au FileType h,c if !&diff | argdelete * | argadd! $PWD/inc*/**/*.h $PWD/s*rc*/**/*.c | endif
	au FileType hpp,cpp,tpp if !&diff | argdelete * | argadd! $PWD/inc*/**/*.?pp $PWD/s*rc*/**/*.cpp | endif
endif

set wildignore=.git,*.o,*.d "wildmenu results to hide
set wildignorecase

"Buffer, Quickfix list, tag and file navigation
nnoremap s <Nop>
nnoremap sa :b#<CR>
nnoremap sd :bn<CR>:bdelete#<CR>
nnoremap sl :ls<CR>:b<space>
nnoremap sn :bn<CR>
nnoremap sp :bp<CR>
nnoremap sf :find *
nnoremap st :tjump /
nnoremap sg :grep!<Space><Space><Space>##<Left><Left><Left><Left>

nnoremap ssn :cn<CR>
nnoremap ssp :cp<CR>
nnoremap ssg :.cc<CR>
nnoremap sso :copen<CR>
nnoremap ssc :cclose<CR>

"Save
nnoremap sw :wa<CR>

"Shell
nnoremap sb :.w !bash<CR>

"Insert Mode : More ergonomic completion
inoremap <C-k> <C-n>
inoremap <C-l> <C-p>
inoremap <C-n> <C-k>
inoremap <C-p> <C-l>

"Make
"SSH problem -> not populating quickfix list with error
"let &makeprg = 'make $* 1>/dev/null' "& to have a local var
let &makeprg = 'make $*' "& to have a local var
nnoremap sm :make<CR>

"Macros

"Lazy HPP rename (So so, need to find a way to reuse capture group or use register as search pattern)
":1,2s/\(\s\)\@<=\w\{-1,}\(_\)\@=/\=toupper(expand('%:t:r'))/
"OR
" :let @c = expand('%:t:r')
" e newclass.hpp
":0r oldclass.hpp
" let @c = 'oldclass'
" exe '3,$%s/' . @c . '/=expand('%:t:r')/g'
" %s//\U~/gi

"smart printf. magic command : C-o to send normal mode command while insert
let @p = '0iprintf(">%<\n", €ýaA);€ýahhbvey2F"pa : €ýaf%a'

"Autocmd for tags files
autocmd BufEnter *.h,*.c,*.hpp,*.cpp,*.tpp :silent !ctags -R
autocmd BufWritePost *.h,*.c,*.hpp,*.cpp,*.tpp :silent !ctags -R
autocmd VimLeave *.h,*.c,*.c,*.hpp,*.cpp,*.tpp :silent !rm tags

"Syntax on for tpp files
autocmd BufEnter *.tpp :setlocal filetype=cpp

"Set cindent for c files
autocmd BufEnter *.c :setlocal cindent

" coloured extra whitespaces
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$\| \+\ze\t\| ^\t*\zs \+/


" SINGLE KEYS
" K for man pages. [n]K for specific section
" z to place current line on top

" FILE INFOS
" gC-g ou C-g ou 1C-g for full name of file

" DELETION
" X to del previous char
" "qcw to delete word inside register q

" MOVE AMONG FILES
" :ju show jump list
" C-o et C-i to move to previous and next position in jump list
" :changes to show list of changes
" g;/g, to go to next/previous change
" */# to go to next/previous occurence of word in normal mode
" g*/g# same line above, but also among can be incomplete word
" d/word to delete from postion till word
" s/p/b/B with a/i for sentence/paragraph/braces/curly_braces
" H,L,M to jump to top, bottom or middle of current view (offset possible) -> USEFULL
" ]m,]M,[m,[M, to jump to next function start/end, previous function start/end -> USEFULL
" ]],][,[[,[], to jump to next function start/end, previous section start/end -> SUPER USEFULL
" gm/gM : go to middle of screen/text on current line -> SUPER USEFULL
" C-e/C-y to scroll view down/up

" MARKS
" `` postion before last jump action, or where last use of m`/m'
" m` or m' to add a jump manually (USEFULL for using with C-o)
" m{a-z} set mark at cursor position
" `{a-z} jump to mark {a-z} in current buffer at exact location (mm and `m USEFULL)
" '{a-z} jump to mark {a-z} in current buffer at first non blank char

" WINDOWS
" C-ww to switch among open windows
" _ to maximize height, | to maximize width
" C-w + H,J,K,L to move window with whole height/width
" :ba[ll] to open all buffers in windows
" windo same as bufdo for windows

" UPPER AND LOWERCASE
" ~ to switch case -> g~MOTION or g~~ for whole line
" U for uppercase and u for lowercase -> gUU

" REGISTERS
" :reg z1 to show only reg z and 1
" "_ is blackhole register
" "Ayy to append to register a whole curent line
" + is clipboard buffer -> from vim and to vim !

" OPTIONS
" set is? to know status of incsearch
" set is! to toggle status of incsearch

" MODES SWITCHES
" norm + cmd in command mode to use normal command in command mode. Usefull after visual selection -> norm i // to comment in c

" MACROS
" C-v to enter litteral char when editing a macro
" C-O to escape insert mode for next command when typing a macro -> USEFULL

" VISUAL MODE
" o to go to other end
" O to got to other corner in visual block on same line
" :ce[nter] to center with base of 80 char. :center 40 for base of 40
" :le[ft] 5 to align left minus 5. Same with ri[ght]
" r useful with visual block

" INDENT
" >ip to indent whole paragraph to right

" MAPPING
" :map to show mappings

" BUFFERS
" bf/bl for first or last buffer
" C-6 or :b# for alternate buffer
" badd file instead of e file to add file without switching directly on it
" range or %bd to close range or all buffers
" bufdo + cmd to do in all buffers -> USEFUL !!!!
" | to make commands one after another
" :E to open navigation buffer (:bd to close without using)

" TERMINAL MODE
" C-w + N to switch to insertion. i to return to terminal

" INSERT MODE
" C-r and register name to paste
" C-p autocomplete word

" INSERT MODE COMPLETION
" C-x C-l autocomplete line -> USEFULL
" C-x C-f autocompalte filenames -> USEFULL

" READ FROM / COPY FROM
" 0:r !ls to read from ls and paste at beginning of file
" C-r C-w to paste current word in command mode -> USEFULL
" C-r + register in command or insertion to paste reg
" [range]t to copy range to current position

" CODE HELPERS
" C-a/C-x to increment or decrement
" g C-a to increment all lines on visual selection -> USEFULL

" POSITON IN CURRENT FILE
" zt/zb/zz to move window so that current line is at top/bottom/middle

" HELP
" :h to_search<C-d> for menu of available choices -> USEFULL

" G MAGIC
" ga display hex and more value of char under cursor
" gf open filename under corsor -> USEFULL
" G=gg to reindent whole document (from bottom up)
" g;/g, go to previous/next changelist position -> USEFULL
" gi go to last edit in file and starts insert mode -> USEFULL

" SHELL OUTPUT
" .!sh execute commande on current line in shell and paste ouput
" !! in normal mode + command. ex !!ls -> SUPER USEFULL
" !! works with selection in visual mode ex !!sort or grep word !!tr -d A -> SUPER USEFULL

" SEARCH AND REPLACE
" # can also be used as a separator
" arg/argadd/argdo %s/patern/replace/ge
" vimgrep pattern ## (## replaced by arglist)
" **/*.c *.c list every c file in dir and subdir
" %s/xxx/\=expand('%:t:r')/g replace every xxx by filename tail and only root ie /bin/file.c -> file
" add /e to jump to end of word when searchin : /word_searched/e

" REGEX
" \0 for previous match
" <cword> for word under cursor
" \<pattern\> for exact pattern
" Ctrl-f to insert a normal mode move. Ctrl-c to end -> SUPER USEFULL

" SAVING AND QUITTING
" ZZ is same as :x -> USEFULL
" C-o C-o : reopen last edited file -> USEFULL at startup

"VI and VIM Editor notes
" :sh to open a shell within wim (easier thant Ctrl-Z and fg)
