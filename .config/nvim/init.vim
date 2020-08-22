" ==================================================
"        _   _                 _           
"       | \ | | ___  _____   _(_)_ __ ___  
"       |  \| |/ _ \/ _ \ \ / / | '_ ` _ \ 
"       | |\  |  __/ (_) \ V /| | | | | | |
"       |_| \_|\___|\___/ \_/ |_|_| |_| |_|
"
"  Config File		  Edited By: Ricardo Gomez
" ==================================================                                      

" ===============================================
"                    VIM-PLUG
" ===============================================

" Check if vim-plug is installed, if not install
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
	Plug 'itchyny/lightline.vim'
	"Plug 'vifm/vifm.vim'
	Plug 'ap/vim-css-color'
	"Plug 'git://github.com/altercation/vim-colors-solarized.git'
	"Plug 'ironcamel/vim-script-runner', {'for': ['sh', 'python']}
call plug#end()
" ===============================================


" Copy to clipboard
set clipboard+=unnamedplus

" Show sidebar numbers
"set number
"set relativenumber
set number relativenumber

set noshowmode
set noshowcmd

syntax enable
set background=dark
"colorscheme solarized

" Alias
command RenameMoviesSeriesFiles % s~\(\d\{4}\|[sS]\d\{1,2}[eExX]\d\{1,2}.\)\@<=.\+\(\.[a-z0-9]\{3,5}\)\@=~~g | % s~[._-]\+\(mp4\|avi\|mkv\|srt\)\@!~ ~g | % s~[([{]\(\d\{4}\)~\1~g 

" Remove Transparency
highlight Normal ctermbg=Black
highlight NonText ctermbg=Black

" Set theme to lightline
" let g:lightline = { 'colorscheme': 'PaperColor' }
