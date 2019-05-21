source ~/.vim/base.vim
source ~/.vim/advanced.vim

if filereadable(expand('~/.vim/custom.vim'))
  source ~/.vim/custom.vim
endif
