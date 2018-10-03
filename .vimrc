" Christopher Fujino's .vimrc
"   For use in Vim (v >= 8.1) & NeoVim

" VARIABLES

syntax on
set number          " Show line numbers.
set wildmenu        " why is this not the default?!
set laststatus=2    " statusline always on
set mouse=a         " enable mouse

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

  " Ruby/Rails
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-bundler'

  " Slim template lang syntax highlighting
  Plug 'onemanstartup/vim-slim', { 'for': 'slim' }

  " JSX syntax
  Plug 'mxw/vim-jsx'
  "let g:jsx_ext_required = 1

  Plug 'mattn/emmet-vim', { 'for': 'html' }

  " better js syntax
  Plug 'pangloss/vim-javascript'

  " Add :Rename, :Move, :Delete, et al
  Plug 'tpope/vim-eunuch'
  
  " Tooling
  Plug 'valloric/youcompleteme'
  let g:ycm_autoclose_preview_window_after_insertion=1
  let g:ycm_filepath_blacklist={}
  let g:ycm_collect_identifiers_from_tags_files=1

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " Asynchronously run linters, see `call neomake...`
  Plug 'neomake/neomake'

  " Vim Maintenance
  " vim-autoread: this periodically reads file from system to check for changes
  Plug 'christopherfujino/vim-autoread'

  " Intelligently deal with swap files
  Plug 'zirrostig/vim-smart-swap'

  " UI
  " show indentation markers
  Plug 'yggdroot/indentLine'

  " Git
  Plug 'tpope/vim-fugitive'
  " show git diff in gutter before line number
  Plug 'airblade/vim-gitgutter'

  " Chris Kempson's Base16 colorschemes, see `colorscheme...`
  Plug 'chriskempson/base16-vim'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme='base16_monokai'
  let g:airline_powerline_fonts=1

" All of your Plugins must be added before the following line
call plug#end()            " required

" PLUGIN VARIABLES
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-monokai

" auto-make on save
call neomake#configure#automake('w')

" KEY MAPPINGS
nnoremap <c-p> :FZF<cr>
