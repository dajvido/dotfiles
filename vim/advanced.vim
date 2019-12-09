" Dein configuration
if &compatible
  set nocompatible
endif

" Dein plugins
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  call dein#add('Shougo/defx.nvim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  if has('nvim')
    call dein#add('neovim/nvim-lsp')
  endif

  call dein#add('Shougo/neosnippet-snippets', { 'on_event': 'InsertEnter' })
  call dein#add('Shougo/neosnippet.vim', { 'depends': 'neosnippet-snippets', 'on_event': 'InsertEnter' })

  call dein#add('terryma/vim-multiple-cursors')

  call dein#add('christoomey/vim-tmux-navigator')

  call dein#add('morhetz/gruvbox')

  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

  call dein#add('tpope/vim-fugitive', { 'on_event': 'CursorHold' })
  call dein#add('tpope/vim-rhubarb')
  call dein#add('airblade/vim-gitgutter')

  call dein#add('scrooloose/nerdcommenter', { 'on_event': 'CursorHold' })

  call dein#add('w0rp/ale')

  call dein#add('pangloss/vim-javascript', { 'on_ft': [ 'js', 'jsx' ]})
  call dein#add('mxw/vim-jsx', { 'on_ft': [ 'js', 'jsx' ]})
  call dein#add('rust-lang/rust.vim', { 'on_ft': [ 'rs' ]})

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

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
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': ['prettier', 'stylelint'],
\   'javascript': ['prettier', 'eslint'],
\   'json': ['prettier', 'jq'],
\   'python': ['autopep8'],
\   'rust': ['rustfmt'],
\   'ruby': ['rubocop'],
\   'scss': ['prettier', 'stylelint']
\}
let g:ale_linters = {'rust': ['rls']}
let g:ale_linters_ignore = {'javascript': ['tsserver']}
nnoremap <silent> <leader>a :ALEFix<CR>
com! FormatJSON %!python -m json.tool

" FZF & Ripgrep
let g:fzf_nvim_statusline=0 " disable statusline overwriting
if executable('rg')
  let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,**/node_modules,**/dist,**/coverage}/*" 2> /dev/null'
  let $FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  set grepprg=rg\ --vimgrep

  command! -bang -nargs=* FindQuick call fzf#vim#grep('rg --column --line-number --no-heading --glob "!.git/*" --glob "!node_modules" --glob "!package-lock.json" --glob "!yarn.lock" --color "always" '.shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%', '?'), <bang>0)
  command! -bang -nargs=* FindQuickInFileParentDir call fzf#vim#grep(printf('rg --column --line-number --no-heading --glob "!.git/*" --glob "!node_modules" --glob "!package-lock.json" --glob "!yarn.lock" --color "always" %s ', shellescape(<q-args>)) . expand('%:h'), 1, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%', '?'), <bang>0)

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
  nnoremap <silent> <leader>G :FindQuickInFileParentDir<CR>
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

" Override mapping for vim-multiple-cursors
let g:multi_cursor_select_all_word_key = '<C-a>'
let g:multi_cursor_select_all_key      = 'g<C-a>'

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

" Defx
autocmd BufWritePost * call defx#redraw()
map <C-P> :Defx `expand('%:p:h')` -search=`expand('%:p')`<CR>
autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
    \ defx#do_action('open')
    nnoremap <silent><buffer><expr> c
    \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
    \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
    \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
    \ defx#do_action('open')
    nnoremap <silent><buffer><expr> E
    \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
    \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> o
    \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> K
    \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
    \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
    \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
    \ defx#do_action('toggle_columns',
    \                'mark:indent:icon:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
    \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
    \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
    \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
    \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
    \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
    \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
    \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
    \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
    \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
    \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
    \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
    \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
    \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
    \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
    \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
    \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
    \ defx#do_action('change_vim_cwd')
  endfunction

" Navigate between ALE errors
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap)

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
