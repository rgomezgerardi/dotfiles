" ====================================================
"
"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
"
"  Config File		     Edited By: Ricardo Gomez
" ====================================================                                      

" Set the caracter encoding
set encoding=utf-8

" Define the shell
set shell=/bin/zsh

" Copy to clipboard
set clipboard+=unnamedplus

" Save as sudo
ca w!! w !sudo tee "%"

" Change the default terminal size
"set termwinsize=10x0

" When scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" No create a swap file
set noswapfile

" Change the <leader> key map
let mapleader = "\\"

" Enables 24-bit RGB color
set termguicolors

" Source Plugins
source $HOME/.config/nvim/plug.vim


" ====================================================                                      
" =================== Appareance =====================
" ====================================================
" Select the color theme
if has('gui_running')
  set background=dark
  colorscheme default
else
  colorscheme onedark
endif

" Show sidebar numbers
set number relativenumber
"hi LineNr ctermbg=NONE ctermfg=darkgrey

" Always show tabline
set showtabline=1

" Turn on syntax highlighting
syntax on

" Display all matching results when we tab complete in command mode
set wildmenu

" Ignore case for completion
set wildignorecase

" Dont show --INSERT-- , --NORMAL-- , etc
set noshowmode
set noshowcmd

" Enable folding
set foldmethod=marker

"set foldmethod=indent
set foldlevel=99
"hi Folded ctermfg=white ctermbg=none

" More natural split opening
set splitbelow splitright

" Removes pipes | that act as seperators on splits
set fillchars+=vert:\ 

"
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar


" ====================================================                                      
" ================== Auto Commands ===================
" ====================================================
if !exists("autocommands_loaded")
	let autocommands_loaded = 1
	
	" Enable syntax highlighting for files formats that are not known by vim, but use the same syntax as file that are known to vim
	autocmd BufEnter,BufRead vifmrc :setfiletype vim
	
	" Open the terminal in insert mode
	autocmd TermOpen * startinsert

	" Running Sh code 
	autocmd FileType sh,bash map <buffer> <F5> :w<CR>:split \| terminal sh<CR>
	autocmd FileType sh,bash imap <buffer> <F5> <esc>:w<CR>:split \| terminal sh<CR>

	" Running Python code 
	autocmd FileType python map <buffer> <F5> :w<CR>:split \| terminal python3 "%"<CR>
	autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:split \| terminal python3 "%"<CR>
endif


" ====================================================                                      
" ================== Key Mappings ====================
" ====================================================
" Split navigations 
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>
map <Leader>th <C-w>t<C-w>H
map <Leader>tv <C-w>t<C-w>K

" Edit and reload vimrc configuration file
nnoremap <Leader>ve :w ; e $MYVIMRC<CR>
nnoremap <Leader>vr :source $MYVIMRC<CR>

" Enable folding with the spacebar
"nnoremap <space> za

" Tab navigation
map tt :tabnew 
map <M-Right> :tabn<CR>
imap <M-Right> <ESC>:tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left> <ESC>:tabp<CR>

" Open terminal
map <Leader>tt :vsplit \| terminal<CR>

" Permanent regex very magic mode (cause interferes with vim's search-history)
"nnoremap / /\v
"vnoremap / /\v
"cnoremap %s/ %smagic/
"cnoremap \>s/ \>smagic/
"nnoremap :g/ :g/\v
"nnoremap :g// :g//

" Yank line without the jump
"nnoremap yy

" Compile and open output
"map <leader>G :w! \| !comp <c-r>%<CR><CR>
"map <leader>o :!opout <c-r>%<CR><CR>
