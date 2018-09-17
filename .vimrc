" Christopher Fujino's .vimrc
"   For use in Vim (v >= 8.1) & NeoVim

" VARIABLES

"filetype off
"filetype plugin indent on    " required
syntax on
set number          " Show line numbers.
set wildmenu        " why is this not the default?!
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

" PLUGINS

" https://github.com/junegunn/vim-plug must be installed to manage plugins
call plug#begin()
  " auto bracket pairing plugin
  Plug 'jiangmiao/auto-pairs'

  " show indentation markers
  Plug 'yggdroot/indentLine'

  " Syntax
  Plug 'tpope/vim-surround'

  " vim-autoread: this periodically reads file from system to check for changes
  Plug 'christopherfujino/vim-autoread'

  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-bundler'
  
  " Chris Kempson's Base16 colorschemes
  Plug 'chriskempson/base16-vim'

  " Asynchronously run linters
  Plug 'neomake/neomake'

  " Intelligently deal with swap files
  Plug 'zirrostig/vim-smart-swap'

  "" better js syntax
  Plug 'pangloss/vim-javascript'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme='base16_monokai'
  let g:airline_powerline_fonts=1

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
  Plug 'junegunn/fzf.vim'

  " Git
  Plug 'tpope/vim-fugitive'
  " Vim-gitgutter: show git diff in gutter before line number
  Plug 'airblade/vim-gitgutter'

  " Autocomplete
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  let g:deoplete#enable_at_startup = 1

  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

  " Slim template lang syntax highlighting
  Plug 'onemanstartup/vim-slim', { 'for': 'slim' }

  "" JSX syntax
  Plug 'mxw/vim-jsx'
  "let g:jsx_ext_required = 1

" All of your Plugins must be added before the following line
call plug#end()            " required

" Plugin variables
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-monokai

" custom keybindings
nnoremap <c-p> :FZF<cr>
