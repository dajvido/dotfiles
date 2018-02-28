"""               """
""" Configuration """
"""               """
highlight ColorColumn ctermbg=10
let g:session_dir='~/.vim/session/' " Path to session directory
set autoindent                      " Automatically indent new line
set backspace=indent,eol,start      " Config backspace
set backup                          " Make backup files
set backupdir=~/.vim/backup/        " Path to backup directory
set clipboard=unnamed,unnamedplus   " Copy paste to clipboard
set colorcolumn=101                 " Highlight vertical column
set cursorline                      " Highlight current line
set directory=~/.vim/swap/          " Path to swap directory
set encoding=utf-8                  " Set encoding required by python extensions
set eol                             " Ensure newline at EOF on save
set expandtab                       " Replace <Tab> with spaces
set laststatus=2                    " Always show the status line
set list lcs=trail:·,tab:»·         " Show trailing spaces and tabs
set number                          " Show current line
set relativenumber                  " Relative line numbers
set shiftround                      " Round indent to multiple of 'shiftwidth' (for << and >>)
set shiftwidth=2                    " Indent size for << and >>
set shiftwidth=2                    " Indent size for << and >>
set softtabstop=2                   " Remove <Tab> symbols as it was spaces
set splitbelow                      " Open split window - bottom
set splitright                      " Open split window - right
set tabstop=2                       " Number of spaces that a <Tab> in the file counts for
set textwidth=0                     " Do not wrap words (insert)
set timeoutlen=300                  " Fix delay problem
set ttimeoutlen=10                  " Fix delay problem
set updatetime=200                  " Set update delay (default 4000ms)

" Set python path For python extensions
let g:python_host_prog='/usr/local/bin/python'
let g:python3_host_prog='/usr/local/bin/python3'

" Theme
filetype plugin indent on
set termguicolors
colorscheme nofrils-dark
let g:nofrils_strbackgrounds=1
let g:nofrils_heavycomments=1
let g:nofrils_heavylinenumbers=1

" Configure Gitgutter
set signcolumn=yes

" Assign leader key
let g:mapleader=","
let g:maplocalleader="\\"

" Syntax
set signcolumn=yes
let g:ale_echo_msg_format = '%severity% [%linter%] %s'

" FZF
set rtp+=/usr/local/opt/fzf
let g:fzf_nvim_statusline = 0 " disable statusline overwriting
let $FZF_DEFAULT_COMMAND='ag -g ""'
let $FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

" Deoplete config
let g:deoplete#enable_at_startup = 1

" Airline tabline
let g:airline_powerline_fonts=1
let g:airline_theme='solarized'
set noshowmode
let g:airline#extensions#tabline#enabled = 1

" Nerdtree
" Close if it's the last tab
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"""          """
""" Bindings """
"""          """
""" FZF mapping selecting mappings
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>w :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>l :Lines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>a :execute 'Ag ' . input('Ag/')<CR>
nnoremap <silent> K :call SearchWordWithAg()<CR>
vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>
nnoremap <silent> <leader>T :Filetypes<CR>

imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)

function! SearchWordWithAg()
  execute 'Ag' expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Ag' selection
endfunction

" Ctrl-N to disable search match highlight
nmap <silent> <C-N> :silent noh<CR>

" Ctrol-E to switch between 2 last buffers
nmap <C-E> :b#<CR>

" Deoplete autocomplete on the key
if has("gui_running")
  inoremap <silent><expr><C-Space> deoplete#mappings#manual_complete()
else
  inoremap <silent><expr><C-@> deoplete#mappings#manual_complete()
endif

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

" Session hotkeys
nnoremap <Leader>sl :wall<Bar>execute "source " . g:session_dir . fnamemodify(getcwd(), ':t')<CR>
nnoremap <Leader>ss :execute "mksession! " . g:session_dir . fnamemodify(getcwd(), ':t')<CR>

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

" Nerdtree
map <C-P> :NERDTreeToggle<CR>
nmap <leader>p :NERDTreeFind<CR>

" Movement within 'ins-completion-menu'
imap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"

" Navigate between ALE errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Nerdcommenter
nmap <leader>/ :call NERDComment(0, "invert")<cr>
vmap <leader>/ :call NERDComment(0, "invert")<cr>

" Files diff
nmap <leader>d :windo :diffthis<CR>

"""    """
"""     """
""" NVIM """
"""       """
"""        """
if has('nvim')
  """         """
  """ Plugins """
  """         """
  call plug#begin('~/.config/nvim/plugged')
  " nofrils-dark theme
  Plug 'robertmeta/nofrils'

  " Lean & mean status/tabline for vim that's light as air
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " fzf is a general-purpose command-line fuzzy finder.
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'

  " Git
  Plug 'tpope/vim-fugitive'

  " Git diff in the number column
  Plug 'airblade/vim-gitgutter'

  " Autocompleter
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " Nerdtree
  Plug 'scrooloose/nerdtree'

  " Commenter
  Plug 'scrooloose/nerdcommenter'

  " Terminal manager
  Plug 'kassio/neoterm'

  " Syntaxes
  Plug 'w0rp/ale'
  Plug 'ngmy/vim-rubocop'

  " Languages
  Plug 'vim-ruby/vim-ruby'
  Plug 'elixir-lang/vim-elixir'

  " Markdown preview
  function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
      if has('nvim')
        !cargo build --release
      else
        !cargo build --release --no-default-features --features json-rpc
      endif
    endif
  endfunction
  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
  call plug#end()

  """          """
  """ Bindings """
  """          """
  " Terminal
  tnoremap <C-q> <C-\><C-n>

  " Neoterminal
  nnoremap <silent> <f10> :TREPLSendFile<cr>
  nnoremap <silent> <f9> :TREPLSend<cr>
  vnoremap <silent> <f9> :TREPLSend<cr>

  " run set test lib
  nnoremap <silent> ,ra :call neoterm#test#run('all')<cr>
  nnoremap <silent> ,rf :call neoterm#test#run('file')<cr>
  nnoremap <silent> ,rc :call neoterm#test#run('current')<cr>
  nnoremap <silent> ,rr :call neoterm#test#rerun()<cr>

  " Useful maps
  nnoremap <silent> ,to :call neoterm#open()<cr>
  nnoremap <silent> ,tc :call neoterm#close()<cr>
  nnoremap <silent> ,tl :call neoterm#clear()<cr>
  nnoremap <silent> ,tk :call neoterm#kill()<cr>

  " Git commands
  command! -nargs=+ Tg :T git <args>

  " Files diff
  nmap <leader>diff :windo :diffthis<CR>
endif
