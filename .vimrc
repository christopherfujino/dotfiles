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
set list            " Highlight trailing whitespace
set textwidth=80    " Maximum width of insert text
set colorcolumn=+1  " Highlight column 1 after textwidth

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

" Mouse
noremap <MiddleMouse> <Nop>
noremap <2-MiddleMouse> <Nop>
noremap <3-MiddleMouse> <Nop>
noremap <4-MiddleMouse> <Nop>

nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>
nnoremap <3-MiddleMouse> <Nop>
nnoremap <4-MiddleMouse> <Nop>

" Never show netrw banner
let g:netrw_banner        = 0

" PLUGINS

" https://github.com/junegunn/vim-plug must be installed to manage plugins
call plug#begin()
  " auto bracket pairing plugin
  Plug 'jiangmiao/auto-pairs'

  " Syntax
  Plug 'tpope/vim-surround'

  " Autocomplete for LSP
  if has('nvim')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
  endif

  Plug 'dart-lang/dart-vim-plugin'

  " Typescript Support
  Plug 'leafgarland/typescript-vim'

  " better js syntax
  Plug 'yuezk/vim-js'

  " Add JSX Syntax
  Plug 'MaxMEllon/vim-jsx-pretty'

  Plug 'chrisbra/csv.vim', { 'for': 'csv' }

  " Typescript
  Plug 'HerringtonDarkholme/yats.vim'

  " Add :Rename, :Move, :Delete, et al
  Plug 'tpope/vim-eunuch'

  " vim-autoread: this periodically reads file from system to check for changes
  Plug 'christopherfujino/vim-autoread'

  " Intelligently deal with swap files
  Plug 'zirrostig/vim-smart-swap'

  " show indentation markers
  Plug 'yggdroot/indentLine' " Note: sets conceallevel=2

  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb' " github plugin for vim-fugitive
  " show git diff in gutter before line number
  Plug 'airblade/vim-gitgutter'

  "Plug 'mattn/emmet-vim', { 'for': 'html' }

  " Chris Kempson's Base16 colorschemes, see `colorscheme...`
  Plug 'chriskempson/base16-vim'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Distraction free mode
  Plug 'junegunn/goyo.vim'

  " Search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call plug#end()

filetype plugin indent on

" PLUGIN VARIABLES
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-eighties

let g:goyo_width=81

" Indentline
let g:indentLine_char = '⎸'
let g:indentLine_bufNameExclude = ["term:.*"] " Don't show in terminal!
let g:indentLine_setConceal = 0 " This was hiding quotes in JSON files

" Dart Style Guide - for vim-dart
let g:dart_style_guide = 2

" FZF Magic
let g:fzf_commits_log_options = '--graph --color=always --all --format="%C(auto)%h %C(black)%C(bold)%cr%C(auto)%d %C(reset)%s"'
let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
noremap <c-p> :Files<cr>

function! s:checkout_clean(branch)
  execute '!git checkout ' . substitute(a:branch, ' ', '', 'g')
endfunction

command! Checkout
      \ call fzf#run({
      \   'source': "git branch | sed 's/*/ /'",
      \   'sink': function('s:checkout_clean')
      \ })

command! EVimrc edit ~/.vimrc

" Execute (!) current file (%) with full path (:p)
command! Execute :! %:p

command! Diffs
      \ call fzf#run({
      \   'source': "git diff --stat | awk '{print $1}' | sed '$ d'",
      \   'sink': 'edit'
      \})

" Vim-Airline Theming
let g:airline_theme='base16_monokai'
let g:airline_powerline_fonts=1
let g:airline_section_b='' " don't show git branch

nnoremap <c-t> :tabe<cr>

" If starting vim with a directory as first (and only) arg, cd into dir
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) | execute 'cd' argv()[0] | endif

" COC
if has('nvim')
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  " <TAB> maps to next completion
  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
  " <S-TAB> maps to previous completion
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  " Navigate coc diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

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
  let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
  let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
endif

autocmd BufWritePost .vimrc :so %

" Syntaxes
"autocmd FileType python set sw=4 tw=4 # this was causing weird newlines
"autocmd FileType cs set sw=4 tw=4
