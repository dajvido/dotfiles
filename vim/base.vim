"""               """
""" Configuration """
"""               """
" Auto-create backup, temp, undo and session dirs in .vim home directory
let g:vimdirs_vimhome = $HOME.'/.vim/'            " Path to Home directory
let g:vimdirs_temp = g:vimdirs_vimhome."temp"     " Path to Temp directory
let g:vimdirs_backup = g:vimdirs_vimhome."backup" " Path to Backup directory
let g:vimdirs_undo = g:vimdirs_vimhome."undo"     " Path to Undo directory
let g:session_dir= g:vimdirs_vimhome."session/"   " Path to Session directory

if !isdirectory(g:vimdirs_vimhome)
  call mkdir(g:vimdirs_vimhome)
endif
if !isdirectory(g:vimdirs_vimhome."backup")
  call mkdir(g:vimdirs_vimhome."backup","p")
endif
if !isdirectory(g:vimdirs_vimhome."temp")
  call mkdir(g:vimdirs_vimhome."temp","p")
endif
if !isdirectory(g:vimdirs_vimhome."undo")
  call mkdir(g:vimdirs_vimhome."undo","p")
endif
if !isdirectory(g:vimdirs_vimhome."session")
  call mkdir(g:vimdirs_vimhome."session","p")
endif
execute "set directory=".escape(g:vimdirs_temp, ' ').'//'
execute "set backupdir=".escape(g:vimdirs_backup, ' ').'//'
execute "set undodir=".escape(g:vimdirs_undo, ' ').'//'

" Set column color
highlight ColorColumn ctermbg=10

" Basic editor configuration
set autoindent                    " Automatically indent new line
set backspace=indent,eol,start    " Config backspace
set backup                        " Make backup files
set clipboard=unnamed,unnamedplus " Copy paste to clipboard
set colorcolumn=101               " Highlight vertical column
set cursorline                    " Highlight current line
set encoding=utf-8                " Set encoding required by python extensions
set eol                           " Ensure newline at EOF on save
set expandtab                     " Replace <Tab> with spaces
set laststatus=2                  " Always show the status line
set list lcs=trail:·,tab:»·       " Show trailing spaces and tabs
set number                        " Show current line
"set relativenumber                " Relative line numbers
set shiftround                    " Round indent to multiple of 'shiftwidth' (for << and >>)
set shiftwidth=2                  " Indent size for << and >>
set shiftwidth=2                  " Indent size for << and >>
set softtabstop=2                 " Remove <Tab> symbols as it was spaces
set splitbelow                    " Open split window - bottom
set splitright                    " Open split window - right
set tabstop=2                     " Number of spaces that a <Tab> in the file counts for
set textwidth=0                   " Do not wrap words (insert)
set timeoutlen=300                " Fix delay problem
set ttimeoutlen=10                " Fix delay problem
set undofile                      " Make undo files
set updatetime=200                " Set update delay (default 4000ms)

"""          """
""" Bindings """
"""          """
" Session hotkeys
nnoremap <Leader>sl :wall<Bar>execute "source " . g:session_dir . fnamemodify(getcwd(), ':t')<CR>
nnoremap <Leader>ss :execute "mksession! " . g:session_dir . fnamemodify(getcwd(), ':t')<CR>

" Ctrl-N to disable search match highlight
nmap <silent> <C-N> :silent noh<CR>

" Ctrol-E to switch between 2 last buffers
nmap <C-E> :b#<CR>

" Switch between tabs
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt

" Remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Remove blank lines at eof
function! TrimEndLines()
  let save_cursor = getpos(".")
  :silent! %s#\($\n\s*\)\+\%$##
  call setpos('.', save_cursor)
endfunction
au BufWritePre * call TrimEndLines()

" Tabs
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>to :tabonly<cr>

" Creating splits with empty buffers in all directions
nnoremap <Leader>hn :leftabove  vnew<CR>
nnoremap <Leader>ln :rightbelow vnew<CR>
nnoremap <Leader>kn :leftabove  new<CR>
nnoremap <Leader>jn :rightbelow new<CR>

" Keep selection after in/outdent
vnoremap < <gv
vnoremap > >gv

" Files diff
nmap <leader>d :windo :diffthis<CR>
