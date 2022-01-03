" ====================================================                                      
" ==================== Keybindigs ====================
" ====================================================
" Change the <leader> keymap
let mapleader = " "


" ====================================================                                      
" ========= Normal, Visual, Operator-pending =========
" ====================================================
" Write all changed buffers and exit Neovim
map ZA			:xa<CR>

" Edit vimrc configuration file
map <Leader>e		:write <Bar> edit $MYVIMRC<CR>

" Reload vimrc configuration file
map <Leader>r		:write <Bar> source $MYVIMRC<CR>

" Open terminal in vertial split
map <Leader>t		:lcd %:p:h <Bar> vsplit <Bar> terminal<CR>

" Window navigation
noremap <Leader>l	<C-l>|			" Clears and redraws the screen
map <C-q>		<C-W><C-C>|		" Close the current window
map <C-j>		<C-W><C-J>|		" Move cursor to window below current one
map <C-k>		<C-W><C-K>|		" Move cursor to window above current one
map <C-l>		<C-W><C-L>|		" Move cursor to window right of current one
map <C-h>		<C-W><C-H>|		" Move cursor to window right of current one

" Window size
"map <silent> <C-Left> :vertical resize +3<CR>
"map <silent> <C-Right> :vertical resize -3<CR>
"map <silent> <C-Up> :resize +3<CR>
"map <silent> <C-Down> :resize -3<CR>
"map <Leader>th <C-w>t<C-w>H
"map <Leader>tv <C-w>t<C-w>K

" Tab navigation
noremap <Leader>j	J|			" Join lines, with a minimum of two lines
noremap <CR>		K|			" Jump to the definition of the keyword under the cursor
map K			gt|			" Go to the next tab page
map J			gT|			" Go to the previous tab page

" Enable folding with the spacebar

" ====================================================                                      
" ====================== Insert ======================
" ====================================================


" ====================================================                                      
" ================== Abbreviations ===================
" ====================================================
