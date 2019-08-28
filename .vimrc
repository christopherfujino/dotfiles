" Christopher Fujino's .vimrc
"   For use in Vim (v >= 8.1) & NeoVim

" System Setup
syntax on
filetype plugin indent off
set encoding=utf-8
scriptencoding utf-8
" for lang client
set hidden

set autoread
set signcolumn=yes  " Always draw sign column
set noshowmode      " Unneccessary since we use airline

set wildmenu        " why is this not the default?!
set number          " Show line numbers.
set mouse=a         " enable mouse
set laststatus=2    " statusline always on

" Indentation
set tabstop=2       " Number of spaces that a <Tab> in the file counts for.
set shiftwidth=2    " Number of spaces to use for each step of autoindent.
set expandtab       " Use the appropriate number of spaces to insert a <Tab>.
set smarttab
set autoindent
set backspace=2     " Backspace through whitespace

" Search
set ignorecase      " Ignore case in search patterns.
set smartcase       " Case sensitive if pattern contains upper case chars
set hlsearch        " Highlight all search matches
set incsearch       " Highlight search matches while typing

" Window Splits
set splitbelow
set splitright      " better defaults for opening new splits!

" Never show netrw banner
let g:netrw_banner        = 0

" PLUGINS

" https://github.com/junegunn/vim-plug must be installed to manage plugins
call plug#begin()
  " auto bracket pairing plugin
  Plug 'jiangmiao/auto-pairs'

  " Syntax
  Plug 'tpope/vim-surround'

  " LSP
  if has('nvim')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
  endif

  Plug 'dart-lang/dart-vim-plugin'

  " Typescript Support
  Plug 'leafgarland/typescript-vim'

  " better js syntax
  Plug 'pangloss/vim-javascript'

  " Add JSX Syntax
  Plug 'mxw/vim-jsx'

  " Add :Rename, :Move, :Delete, et al
  Plug 'tpope/vim-eunuch'

  " vim-autoread: this periodically reads file from system to check for changes
  Plug 'christopherfujino/vim-autoread'

  " Intelligently deal with swap files
  Plug 'zirrostig/vim-smart-swap'

  " Asynchronously invoke external tools in new Tmux pane
  "Plug 'tpope/vim-dispatch'

  " show indentation markers
  Plug 'yggdroot/indentLine'

  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb' " github plugin for vim-fugitive
  " show git diff in gutter before line number
  Plug 'airblade/vim-gitgutter'
  Plug 'w0rp/ale' " Asynchronously run linters

  " Ruby/Rails
  "Plug 'tpope/vim-rails'
  "Plug 'tpope/vim-bundler'
  "Plug 'tpope/vim-endwise'

  " Slim template lang syntax highlighting
  "Plug 'onemanstartup/vim-slim', { 'for': 'slim' }

  "Plug 'mattn/emmet-vim', { 'for': 'html' }

  " Chris Kempson's Base16 colorschemes, see `colorscheme...`
  Plug 'chriskempson/base16-vim'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Tooling

  " Search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call plug#end()

filetype plugin indent on

" PLUGIN VARIABLES
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-monokai

" Indentline
let g:indentLine_char = '▏'
let g:indentLine_bufNameExclude = ["term:.*"] " Don't show in terminal!

" ALE
nnoremap <c-l> :ALELint<cr>
let g:ale_linters = {
      \'javascript': ['eslint'],
      \'ruby': ['rubocop'],
      \'sh': ['shellcheck'],
      \'dart': [],
      \}
let g:ale_set_highlights=0
let g:ale_echo_msg_format='[%linter%: %code%] %s (%severity%)'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_history_enabled=0
highlight ALEErrorSign ctermfg=1 ctermbg=18
let g:ale_lint_delay=750
let g:ale_echo_delay=125
let g:ale_lint_on_text_changed='normal'
let g:ale_lint_on_insert_leave=1
let g:ale_maximum_file_size=250000

" Dart Style Guide - for vim-dart
let g:dart_style_guide = 2

" FZF Magic
let g:fzf_commits_log_options = '--graph --color=always --all --format="%C(auto)%h %C(black)%C(bold)%cr%C(auto)%d %C(reset)%s"'
let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
noremap <c-p> <esc>:Files<cr>

function! s:checkout_clean(branch)
  execute '!git checkout ' . substitute(a:branch, ' ', '', 'g')
endfunction

command! Checkout
      \ call fzf#run({
      \   'source': "git branch | sed 's/*/ /'",
      \   'sink': function('s:checkout_clean')
      \ })

command! EVimrc edit ~/.vimrc

command! Diffs
      \ call fzf#run({
      \   'source': "git diff --stat | awk '{print $1}' | sed '$ d'",
      \   'sink': 'edit'
      \})

" Vim-Airline Theming
let g:airline_theme='base16_monokai'
let g:airline_powerline_fonts=1

nnoremap <c-t> :tabe<cr>
nnoremap <c-left> :tabprevious<cr>
nnoremap <c-right> :tabnext<cr>

" If starting vim with a directory as first (and only) arg, cd into dir
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) | execute 'cd' argv()[0] | endif

" COC

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" <TAB> maps to next completion
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
" <S-TAB> maps to previous completion
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
nnoremap <silent> K :call <SID>show_documentation()<CR>

highlight link CocErrorSign ALEErrorSign

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" show coc diagnostics in airline
if has('nvim')
  let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
  let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
endif

autocmd BufWritePost .vimrc :so %
