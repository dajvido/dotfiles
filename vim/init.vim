source ~/.vim/base.vim
source ~/.vim/advanced.vim
source ~/.vim/advanced.lua

if filereadable(expand('~/.vim/custom.vim'))
  source ~/.vim/custom.vim
endif
