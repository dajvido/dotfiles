" Set python path For python extensions
let g:python_host_prog='/usr/local/bin/python'
let g:python3_host_prog='/usr/local/bin/python3'

" Dein configuration
if &compatible
  set nocompatible
endif

" Dein plugins
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
if dein#load_state(expand('~/.vim/dein'))
  call dein#begin(expand('~/.vim/dein'))

  call dein#add('Shougo/dein.vim')

  call dein#add('Shougo/deoplete.nvim', { 'on_event': 'InsertEnter' })
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#add('robertmeta/nofrils')

  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

  call dein#add('tpope/vim-fugitive', { 'on_event': 'CursorHold' })
  call dein#add('airblade/vim-gitgutter')

  call dein#add('scrooloose/nerdtree', { 'lazy': 1 })
  call dein#add('scrooloose/nerdcommenter', { 'on_event': 'CursorHold' })

  call dein#add('w0rp/ale')

  if has('nvim')
    call dein#add('kassio/neoterm')
  end

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

" Assign leader key
let g:mapleader=","
let g:maplocalleader="\\"

" Theme
filetype plugin indent on
set termguicolors
colorscheme nofrils-dark
"let g:nofrils_strbackgrounds=1
"let g:nofrils_heavycomments=1
"let g:nofrils_heavylinenumbers=1

" Syntax
set signcolumn=yes
let g:ale_echo_msg_format='%severity% [%linter%] %s'

" FZF
let g:fzf_nvim_statusline=0 " disable statusline overwriting
let $FZF_DEFAULT_COMMAND='ag -g ""'
let $FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
  let old_reg=getreg('"')
  let old_regtype=getregtype('"')
  let old_clipboard=&clipboard
  set clipboard&
  normal! ""gvy
  let selection=getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard=old_clipboard
  execute 'Ag' selection
endfunction

" Deoplete config
let g:deoplete#enable_at_startup=1
inoremap <silent><expr> <Tab>
    \ pumvisible() ? "\<C-n>" : deoplete#manual_complete()

" Movement within 'ins-completion-menu'
imap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"

" Airline tabline
let g:airline_powerline_fonts=1
let g:airline_theme='solarized'
set noshowmode
let g:airline#extensions#tabline#enabled=1

" Nerdtree
" Close if it's the last tab
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-P> :NERDTreeToggle<CR>
nmap <leader>p :NERDTreeFind<CR>

" Navigate between ALE errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Nerdcommenter
nmap <leader>/ :call NERDComment(0, "invert")<cr>
vmap <leader>/ :call NERDComment(0, "invert")<cr>

if has('nvim')
  " Terminal
  tnoremap <C-q> <C-\><C-n>

  " Neoterminal
  nnoremap <silent> <leader>. :Ttoggle<cr>
  nnoremap <silent> <C-l> :Tclear1<cr>

  " Git commands
  command! -nargs=+ Tg :T git <args>

  " Files diff
  nmap <leader>diff :windo :diffthis<CR>
endif
