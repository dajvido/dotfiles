highlight ColorColumn ctermbg=10
set autoindent                    " Automatically indent new line
set backspace=indent,eol,start    " Config backspace
set clipboard=unnamed,unnamedplus " Copy paste to clipboard
set colorcolumn=101               " highlight column
set eol                           " Ensure newline at EOF on save
set expandtab                     " Replace <Tab with spaces
set number                        " Show current line
set relativenumber                " Relative line numbers
set shiftround                    " Round indent to multiple of 'shiftwidth' (for << and >>)
set shiftwidth=2                  " Indent size for << and >>
set softtabstop=2                 " Remove <Tab> symbols as it was spaces
set tabstop=2                     " Number of spaces that a <Tab> in the file counts for
set textwidth=0                   " Do not wrap words (insert)
set updatetime=200                " Set update delay (default 4000ms)

""" Configure Neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_select = 1
imap <expr><C-j>      pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr><C-k>      pumvisible() ? "\<C-p>" : "\<C-k>"
inoremap <expr><C-l>  neocomplete#mappings#complete_common_string()
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
