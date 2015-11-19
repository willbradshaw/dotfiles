" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Ignore case during search unless pattern contains an uppercase letter
set ignorecase
set smartcase

" Make backspace behave in a sane manner.
set backspace=indent,eol,start

" Switch syntax highlighting on
syntax on
 
" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

" Show line numbers
set number

" Allow hidden buffers, don't limit to 1 file per window/split
set hidden

" Remember last 1000 commands
set history=1000

" Split config
set splitbelow
set splitright
nnoremap <C-W><C-Down> <C-W><C-J>
nnoremap <C-W><C-Up> <C-W><C-K>
nnoremap <C-W><C-Right> <C-W><C-L>
nnoremap <C-W><C-Left> <C-W><C-H>

" Highlight text going over 80 characters
highlight OverLength ctermbg=blue ctermfg=white guibg=#592929
match OverLength /\%74v.\+/

" Configure tab spacing
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" Disable Ex mode
nnoremap Q :

" makes j & k work properly with wrapped text
nnoremap j gj
nnoremap k gk

" vim clipboard is system clipboard!
if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
endif

" set trailing whitespace to grey not red
highlight ExtraWhitespace ctermbg=grey guibg=grey

" Show tabs
set list listchars=tab:»\ ,trail:·,extends:>,precedes:<
