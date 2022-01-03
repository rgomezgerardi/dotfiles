" Check if vim-plug is installed, if not install
" stdpath("data")
if empty(expand(glob('~/.local/share/nvim/site/autoload/plug.vim')))
	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync
	source $MYVIMRC
endif

" Start vim plug
call plug#begin()


" ====================================================                                      
" ================== Colorscheme =====================
" ====================================================
Plug 'joshdick/onedark.vim'

" Set color mode
let g:onedark_termcolors = 16

" Enable comments italics
let g:onedark_terminal_italics = 1

" Override default colors
let g:onedark_color_overrides = {
\ "black": {"gui": "#2F343F", "cterm": "235", "cterm16": "0" },
\ "white": {"gui": "#dbdfe1", "cterm": "235", "cterm16": "7" },
\ "comment_grey": {"gui": "#838f9b", "cterm": "235", "cterm16": "15" },
\ "purple": { "gui": "#C678DF", "cterm": "170", "cterm16": "5" }
\}


" ====================================================                                      
" =============== Syntax Highlighting ================
" ====================================================
Plug 'machakann/vim-highlightedyank'		" Yank
Plug 'ap/vim-css-color'				" Hexadecimal Calors
Plug 'markonm/traces.vim'			" Regex
	
" Change yank highlight duration 
let g:highlightedyank_highlight_duration = 1000


" ====================================================
" ==================== Status Bar ====================
" ====================================================
Plug 'itchyny/lightline.vim'

" Set the colorscheme
let g:lightline = { 'colorscheme': 'onedark', }


" ====================================================
" =================== File Search ====================
" ====================================================
	

" ====================================================
" =================== File Browser ===================
" ====================================================
"Plug 'preservim/nerdtree'
"Plug 'vifm/vifm.vim'

"Tweaks for browsing
let g:netrw_usetab = 1					" Enable shrinking/expanding a netrw window
let g:netrw_banner = 0					" Disable annoying banner
"let g:netrw_browse_split = 4				" Open in prior window
"let g:netrw_altv = 1					" Open splits to the right
"let g:netrw_liststyle = 3				" Tree view
"let g:netrw_list_hide = netwr_gitignore#Hide()
"let g:netrw_list_hide. = ',\(^\|\s\s\)\zs\.\S\+'

" Keybindigs
nmap <Leader><tab> :10Lexplore<CR>

"now we can: 
"1.- edit a folder to open a file browser 
"2.- <CR>\v\t to open in a h-split\v-split\tab 
"3.-check | netrw-browse-maps| for more mappings
	
" " Map a specific key or shortcut to open NERDTree
" map <C-n> :NERDTreeToggle<CR>
" 
" " Open a NERDTree automatically when vim starts up if no files were specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" 
" " Open NERDTree automatically when vim starts up on opening a directory
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
 
" " How can I change default arrows
" let g:NERDTreeDirArrowExpandable = '▸'
" let g:NERDTreeDirArrowCollapsible = '▾'
" 
" " Hide .pyc files
" "let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
" 
" let NERDTreeShowLineNumbers=1
" let NERDTreeShowHidden=1
" let NERDTreeMinimalUI = 1
" let g:NERDTreeWinSize=38


" ====================================================
" =================== Tag Jumping ====================
" ====================================================


" ====================================================
" ===================== Snippets =====================
" ====================================================

" Html
nnoremap ,html :-1read $HOME/.config/nvim/snippets/skeleton.html<CR>6jwf>a


" ====================================================
" ==================== Completion ====================
" ====================================================
" Completion
" Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
" Plug 'Shougo/neco-vim'				" Vim 
" Plug 'deoplete-plugins/deoplete-zsh'			" Zsh
" Plug 'davidhalter/jedi'				" Python
" Plug 'fszymanski/deoplete-emoji'			" Emoji



" ^x^n for just this file
" ^x^f for filenames (work with our path trick!)
" ^x^]
" ^n for enything specifie by the complete option (^p reverse)
" help ins-completion


" ====================================================
" ===================== Markdown =====================
" ====================================================
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }	" Preview
" Set to open the preview window after entering the markdown buffer
"let g:mkdp_auto_start = 1

" Set to refresh markdown preview when save the buffer or leave from insert mode
"let g:mkdp_refresh_slow = 1

" Set to the MarkdownPreview command can be use for all files
"let g:mkdp_command_for_global = 1

" Use a custom markdown preview style
"let g:mkdp_markdown_css = expand('~/markdown.css')


" ====================================================
" ====================== Folding =====================
" ====================================================
let g:xml_syntax_folding = 1
set foldmethod=syntax


" ====================================================
" ====================== Others ======================
" ====================================================
"Plug 'preservim/nerdcommenter'			" Comments
Plug 'jiangmiao/auto-pairs'			" Auto Pairs
"Plug 'tpope/vim-surround'			" Surroundings
" Plug 'chrisbra/csv.vim'			" Spreadsheets
"Plug 'vimwiki/vimwiki'				" Notes 

" Add comment spaces after comment delimiters by default
"let g:NERDSpaceDelims = 1

" Use comment compact syntax for prettified multi-line comments
"let g:NERDCompactSexyComs = 1

" Enable auto pairs fly mode
"let g:AutoPairsFlyMode = 1


" End of vim plug (Don't delete this)
call plug#end()
