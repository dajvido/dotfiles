" Set python path For python extensions
let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

" Dein configuration
if &compatible
  set nocompatible
endif

" Dein plugins
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
if dein#load_state(expand('~/.vim/dein'))
  call dein#begin(expand('~/.vim/dein'))

  call dein#add('Shougo/deoplete.nvim', { 'on_event': 'InsertEnter' })
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#add('Shougo/neosnippet-snippets', { 'on_event': 'InsertEnter' })
  call dein#add('Shougo/neosnippet.vim', { 'depends': 'neosnippet-snippets', 'on_event': 'InsertEnter' })

  call dein#add('robertmeta/nofrils')
  call dein#add('morhetz/gruvbox')

  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

  call dein#add('tpope/vim-fugitive', { 'on_event': 'CursorHold' })
  call dein#add('tpope/vim-rhubarb')
  call dein#add('airblade/vim-gitgutter')

  call dein#add('scrooloose/nerdtree', { 'lazy': 1 })
  call dein#add('scrooloose/nerdcommenter', { 'on_event': 'CursorHold' })

  call dein#add('w0rp/ale')

  call dein#add('pangloss/vim-javascript', { 'on_ft': [ 'js', 'jsx' ]})
  call dein#add('mxw/vim-jsx', { 'on_ft': [ 'js', 'jsx' ]})

  if has('nvim')
    call dein#add('kassio/neoterm')
  end

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

" Theme
set termguicolors
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'

" Syntax
set signcolumn=yes
let g:ale_echo_msg_format='%severity% [%linter%] %s'
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\}
nnoremap <silent> <leader>a :ALEFix<CR>
com! FormatJSON %!python -m json.tool

" FZF & Ripgrep
let g:fzf_nvim_statusline=0 " disable statusline overwriting
if executable('rg')
  let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,**/node_modules,**/dist}/*" 2> /dev/null'
  let $FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  set grepprg=rg\ --vimgrep

  command! -bang -nargs=* FindQuick call fzf#vim#grep('rg --column --line-number --no-heading --glob "!.git/*" --glob "!node_modules" --glob "!package-lock.json" --glob "!yarn.lock" --color "always" '.shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%', '?'), <bang>0)

  function! SearchWordWithRipgrep(findFunction)
    execute a:findFunction expand('<cword>')
  endfunction

  function! SearchVisualSelectionWithRipgrep(findFunction) range
    let old_reg=getreg('"')
    let old_regtype=getregtype('"')
    let old_clipboard=&clipboard
    set clipboard&
    normal! ""gvy
    let selection=getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard=old_clipboard
    execute a:findFunction selection
  endfunction

  nnoremap <silent> <leader>g :FindQuick<CR>
  nnoremap <silent> K :call SearchWordWithRipgrep('FindQuick')<CR>
  vnoremap <silent> K :call SearchVisualSelectionWithRipgrep('FindQuick')<CR>
endif

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>w :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>l :Lines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>c :Commits<CR>
nnoremap <silent> <leader>C :BCommits<CR>
nnoremap <silent> <leader>T :Filetypes<CR>

imap <C-x><C-f> <plug>(fzf-complete-file)
imap <C-x><C-p> <plug>(fzf-complete-path)
imap <C-x><C-l> <plug>(fzf-complete-line)

" Deoplete config
let g:deoplete#enable_at_startup=1

" Movement within 'ins-completion-menu'
imap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" Neosnippet config
let g:neosnippet#snippets_directory='~/.vim/snippets'
imap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
smap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
xmap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_target)" : "\<Tab>"

" Airline tabline
let g:airline_powerline_fonts=1
let g:airline_theme='gruvbox'
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
let g:NERDSpaceDelims=1
nmap <leader>/ :call NERDComment(0, "invert")<cr>
vmap <leader>/ :call NERDComment(0, "invert")<cr>

if has('nvim')
  " Neoterminal
  " let g:neoterm_autoinsert = 1
  let g:neoterm_default_mod = ':vertical'
  inoremap <silent><C-s> <esc>:Ttoggle<CR>
  nnoremap <silent><C-l> :Tclear1<cr>
  nnoremap <silent><C-s> :Ttoggle<CR>
  tnoremap <C-q> <C-\><C-n>
  tnoremap <silent><C-s> <C-\><C-n>:Ttoggle<CR>

  " Git commands
  command! -nargs=+ Tg :T git <args>

  " Files diff
  nmap <leader>d :windo :diffthis<CR>
endif
