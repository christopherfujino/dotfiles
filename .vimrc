" Christopher Fujino's .vimrc
"   For use in Vim (v >= 8.1) & NeoVim

" Variables

syntax on
set number          " Show line numbers.
set wildmenu        " why is this not the default?!
set mouse=a         " enable mouse
set laststatus=2    " statusline always on

" Indentation
set tabstop=2       " Number of spaces that a <Tab> in the file counts for.
set shiftwidth=2    " Number of spaces to use for each step of (auto)indent.
set expandtab       " Use the appropriate number of spaces to insert a <Tab>.
                    " Spaces are used in indents with the '>' and '<' commands
                    " and when 'autoindent' is on. To insert a real tab when
                    " 'expandtab' is on, use CTRL-V <Tab>.
set smarttab        " When on, a <Tab> in front of a line inserts blanks
                    " according to 'shiftwidth'. 'tabstop' is used in other
                    " places. A <BS> will delete a 'shiftwidth' worth of space
                    " at the start of the line.
set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O"
                    " command).
set backspace=2     " Influences the working of <BS>, <Del>, CTRL-W
                    " and CTRL-U in Insert mode. This is a list of items,
                    " separated by commas. Each item allows a way to backspace
                    " over something.

" Search
set ignorecase      " Ignore case in search patterns.
set smartcase       " Override the 'ignorecase' option if the search pattern
                    " contains upper case characters.
set incsearch       " While typing a search command, show immediately where the
                    " so far typed pattern matches.
set hlsearch        " When there is a previous search pattern, highlight all
                    " its matches.

" Window Splits
set splitbelow
set splitright      " better defaults for opening new splits!

" Plugins

" https://github.com/junegunn/vim-plug must be installed to manage plugins
call plug#begin()

" Chris Kempson's Base16 colorschemes
Plug 'chriskempson/base16-vim'

" auto bracket pairing plugin
Plug 'jiangmiao/auto-pairs'

" show indentation markers
Plug 'yggdroot/indentLine'

""TPOPE!!!
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-rails'
"Plug 'tpope/vim-bundler'
"Plug 'tpope/vim-dispatch'
"Plug 'neomake/neomake'

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

"" for easy profiling vim startuptime
"Plug 'tweekmonster/startuptime.vim', { 'on' : 'StartupTime' }

"" Slim template lang syntax highlighting
"Plug 'onemanstartup/vim-slim', { 'for': 'slim' }
"
"" JSX syntax
"Plug 'mxw/vim-jsx'
""let g:jsx_ext_required = 1
"
"" CSV formatting
"Plug 'chrisbra/csv.vim', { 'for': 'csv' }
"
"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif
"let g:deoplete#enable_at_startup = 1
"
"" nerdtree-git-plugin
"Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTree' }
"
"" Vim-gitgutter: show git diff in gutter before line number
"Plug 'airblade/vim-gitgutter'
"
"set wildignore+=*/node_modules/*,*/cache/*,*/tmp/*,*/test/reports/*

"" vim-autoread
"" - this periodically reads file from system to check for changes
"Plug 'christopherfujino/vim-autoread'
"
" All of your Plugins must be added before the following line
call plug#end()            " required

let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-monokai









"set nocompatible
"filetype off
"
"filetype plugin indent on    " required
"

"" Neomake config
"call neomake#configure#automake('w')
"let g:neomake_javascript_enabled_makers = ['eslint']
"let g:neomake_ruby_enabled_makers = ['rubocop']
"
"" custom keybindings
"nnoremap <c-p> :FZF<cr>
"
"" Vim settings
"
"" .vimrc
"" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details
"
"" For multi-byte character support (CJK support, for example):
""set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1
"       
 
"set showcmd         " Show (partial) command in status line.
"
""set relativenumber  " change line numbers to relative
"
"set showmatch       " When a bracket is inserted, briefly jump to the matching
"                    " one. The jump is only done if the match can be seen on the
"                    " screen. The time to show the match can be set with
"                    " 'matchtime'.
" 
" 
"set formatoptions=c,q,r,t " This is a sequence of letters which describes how
"                    " automatic formatting is to be done.
"                    "
"                    " letter    meaning when present in 'formatoptions'
"                    " ------    ---------------------------------------
"                    " c         Auto-wrap comments using textwidth, inserting
"                    "           the current comment leader automatically.
"                    " q         Allow formatting of comments with "gq".
"                    " r         Automatically insert the current comment leader
"                    "           after hitting <Enter> in Insert mode. 
"                    " t         Auto-wrap text using textwidth (does not apply
"                    "           to comments)
