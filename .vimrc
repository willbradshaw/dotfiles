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
match OverLength /\%80v.\+/

" Configure tab spacing
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

" Persistent undo settings
set undodir=~/.vim/undo
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" Customised footline
set statusline="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L"

" // to search for visually-highlighted text
vnoremap // y/<C-R>"<CR>

" Set saved scripts to be immediately executable from the shell
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent execute "!chmod +x <afile>" | endif | endif

" Move lines up and down with Ctrl-k/j
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Make j and k work sensibly (i.e. on visual lines) 
" Make gj and gk work how j and k did
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

" Create new lines without entering insert mode
nnoremap go o<Esc>
nnoremap gO O<Esc>
