" Christopher Fujino's .vimrc
"   For use in Vim (v >= 8.1) & NeoVim

" System Setup
syntax on
filetype plugin indent on
set encoding=utf-8
scriptencoding utf-8

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
let g:netrw_banner = 0

" PLUGINS

" https://github.com/junegunn/vim-plug must be installed to manage plugins
call plug#begin()
  " auto bracket pairing plugin
  Plug 'jiangmiao/auto-pairs'

  " Syntax
  Plug 'tpope/vim-surround'

  " Add :Rename, :Move, :Delete, et al
  Plug 'tpope/vim-eunuch'
  
  " vim-autoread: this periodically reads file from system to check for changes
  Plug 'christopherfujino/vim-autoread'

  " Intelligently deal with swap files
  Plug 'zirrostig/vim-smart-swap'

  " show indentation markers
  Plug 'yggdroot/indentLine'

  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  " show git diff in gutter before line number
  Plug 'airblade/vim-gitgutter'

  " Asynchronously run linters
  Plug 'w0rp/ale'

  " JS
  " better js syntax
  Plug 'pangloss/vim-javascript'

  " Add JSX Syntax
  Plug 'mxw/vim-jsx'

  " Ruby/Rails
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-bundler'
  Plug 'tpope/vim-endwise'

  " Slim template lang syntax highlighting
  Plug 'onemanstartup/vim-slim', { 'for': 'slim' }

  Plug 'mattn/emmet-vim', { 'for': 'html' }

  " Chris Kempson's Base16 colorschemes, see `colorscheme...`
  Plug 'chriskempson/base16-vim'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Tooling
  Plug 'valloric/youcompleteme'

  Plug 'majutsushi/tagbar'

  " Search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call plug#end()

" PLUGIN VARIABLES
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-monokai

" ALE
noremap <c-l> <esc>:ALELint<cr>
let g:ale_linters = {
      \'javascript': ['eslint'],
      \'ruby': ['rubocop'],
      \'sh': ['shellcheck']
      \}
let g:ale_lint_delay=750
let g:ale_echo_delay=125
let g:ale_set_highlights=0
let g:ale_echo_msg_format='[%linter%: %code%] %s (%severity%)'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_history_enabled=0
let g:ale_lint_on_text_changed='normal'
let g:ale_lint_on_insert_leave=1
let g:ale_maximum_file_size=250000
highlight ALEErrorSign ctermfg=1 ctermbg=18

" Generate Vimtags
command! Vtags !ctags -R --fields=+l .

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_filepath_blacklist={}
let g:ycm_collect_identifiers_from_tags_files=1

" FZF Magic
let g:fzf_commits_log_options = '--graph --color=always --all --format="%C(auto)%h %C(black)%C(bold)%cr%C(auto)%d %C(reset)%s"'
let $FZF_DEFAULT_COMMAND='rg --hidden --files'
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

command! Diffs
      \ call fzf#run({
      \   'source': "git diff --stat | awk '{print $1}' | sed '$ d'",
      \   'sink': 'edit'
      \})

" Vim-Airline Theming
let g:airline_theme='base16_monokai'
let g:airline_powerline_fonts=1

noremap <c-t> <esc>:tabe<cr>
