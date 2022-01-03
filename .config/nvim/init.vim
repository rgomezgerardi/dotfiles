" ==================================================== 
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
" Change the default terminal size
"set termwinsize=10x0

" When scrolling, keep cursor away from screen border
set scrolloff=3

" No create a swap file
set noswapfile

" Enables 24-bit RGB color
set termguicolors

" Source Keybindings
if !empty(expand(glob('~/.config/nvim/keys.vim'))) | source $HOME/.config/nvim/keys.vim | endif
" stdpath("config")
" Source Plugins
if !empty(expand(glob('~/.config/nvim/plug.vim'))) | source $HOME/.config/nvim/plug.vim | endif


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

" Ignore upper/lower case when searching
"set ignorecase

" Show partial matches for a search phrase
"set incsearch

" Highlight all matching phrases
"set hlsearch

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
"set noshowcmd

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

" Number of spaces that a <Tab> in the file counts for
set tabstop=8

" Number of spaces to use for each step of (auto)indent
set shiftwidth=4

" Number of spaces that a <Tab> counts for while performing editing
" operations, like inserting a <Tab> or using <BS>.  It "feels" like
" <Tab>s are being inserted, while in fact a mix of spaces and <Tab>s is used 
set softtabstop=-1

"In Insert mode: (don't) Use the appropriate number of spaces to insert a <Tab>
set noexpandtab

" When on, a <Tab> in front of a line inserts blanks according to
" 'shiftwidth'.  'tabstop' or 'softtabstop' is used in other places
set smarttab

" Copy indent from current line when starting a new line (typing <CR>
" in Insert mode or when using the "o" or "O" command)
set noautoindent

" Do smart autoindenting when starting a new line
set nosmartindent

" Enables automatic C program indenting
set nocindent
" ====================================================                                      
" ====================== Alias =======================
" ====================================================
" Save as sudo
ca w!! w !sudo tee "%"


" ====================================================                                      
" ================== Auto Commands ===================
" ====================================================
" Disable automatic comment insertion (:set formatoptions?)
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

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
