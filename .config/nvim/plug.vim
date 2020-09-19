" ====================================================                                      
" =================== Vim Plug =======================
" ====================================================
" Check if vim-plug is installed, if not install
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
	" Status Bar	
	Plug 'itchyny/lightline.vim'
	" File Browser
	Plug 'preservim/nerdtree'
	"Plug 'vifm/vifm.vim'
	"Syntax Highlighting and Colors
	Plug 'ap/vim-css-color'
	"Plug 'git://github.com/altercation/vim-colors-solarized.git'
call plug#end()


" ====================================================                                      
" =================== Lightline ======================
" ====================================================
" Set the colorscheme
let g:lightline = { 'colorscheme': 'onedark', }


" ====================================================                                      
" ==================== NerdTree ======================
" ====================================================
" Map a specific key or shortcut to open NERDTree
map <C-n> :NERDTreeToggle<CR>

" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" How can I change default arrows
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Hide .pyc files
"let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38
