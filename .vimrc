" Christopher Fujino's .vimrc
"   For use in Vim & NeoVim

set nocompatible
filetype off

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" https://github.com/junegunn/vim-plug must be installed to manage plugins
call plug#begin()

" for easy profiling vim startuptime
Plug 'tweekmonster/startuptime.vim', { 'on' : 'StartupTime' }

" Plug 'edkolev/tmuxline.vim'  " only necessary temporarily for sourcing /etc/tmux.conf

" let g:tmuxline_preset = {
"   \'a'    : "#(ip addr | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d '/' -f 1)",
"   \'win'  : ['#I', '#W'],
"   \'cwin' : ['#I', '#F#W'],
"   \'y'    : ['%a %b %d'],
"   \'z'    : '%r',
"   \'options': { 'status-justify': 'left'}}
" let g:tmuxline_powerline_separators = 0

"TPOPE!!!
Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-rails'

Plug 'tpope/vim-surround'

"Plug 'scrooloose/syntastic'

" https://github.com/Shutnik/jshint2.vim
" Plug 'Shutnik/jshint2.vim'
" let jshint2_read = 1
" let jshint2_save = 1

" better js syntax
Plug 'pangloss/vim-javascript'

" Slim template lang syntax highlighting
"Plug 'slim-template/vim-slim', { 'for': 'slim' } " this is slow!
Plug 'onemanstartup/vim-slim', { 'for': 'slim' }

" JSX syntax
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0

" Autocompletion - uses vim's built-in omnicomplete; build using
" ~/.vim/plugged/youcompleteme/install.py --tern-completer
Plug 'valloric/youcompleteme'
" if !exists("g:ycm_semantic_triggers")
"   let g:ycm_semantic_triggers = {}
"   let g:ycm_semantic_triggers['typescript'] = ['.']
" endif

" Tern Plugin for Vim (`npm install` must be run inside tern_for_vim directory)
" in Arch Linux, I had to additionally install `sudo pacman -S python2-neovim
" python-neovim` found from github installation guide to neovim
"Plug 'ternjs/tern_for_vim'

" Plug 'bling/vim-airline' vim status-line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='base16_monokai'
let g:airline_powerline_fonts=0
set laststatus=2

" Plug 'jiangmiao/auto-pairs' auto bracket pairing plugin
Plug 'jiangmiao/auto-pairs'

" The Nerd Tree: A tree explorer plugin for vim
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }

" nerdtree-git-plugin
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTree' }

" distraction free writing
"Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'

" Quicktask: a lightweight Vim task management plugin
"Plug 'aaronbieber/vim-quicktask'

" show indentation markers
Plug 'yggdroot/indentLine'

" Vim-gitgutter: show git diff in gutter before line number
Plug 'airblade/vim-gitgutter'

" Control-P fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
set wildignore+=*/node_modules/*,*/cache/*

" Chris Kempson's Base16 colorschemes
Plug 'chriskempson/base16-vim'

" https://github.com/Shutnik/jshint2.vim
" Plug 'Shutnik/jshint2.vim'
" let jshint2_read = 1
" let jshint2_save = 1

" vim-autoread
" - this periodically reads file from system to check for changes
Plug 'christopherfujino/vim-autoread'

" typescript syntax theme
Plug 'leafgarland/typescript-vim', { 'for': 'ts' }

" Vue syntax theme
Plug 'posva/vim-vue', { 'for': 'vue' }

" HTML Plugins

" Emmet for vim
Plug 'mattn/emmet-vim', { 'for': [ 'html', 'htm', 'css', 'sass', 'scss' ] }

" MatchTag - highlights matching HTML tag
Plug 'gregsexton/MatchTag'

" Pug syntax highlighting
Plug 'digitaltoad/vim-pug', { 'for': [ 'pug', 'jade' ] }

" All of your Plugins must be added before the following line
call plug#end()            " required

"These are from the Syntastic readme
"set statusline+=%#warmingmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_javascript_checkers = ['standard']

set wildmenu " why is this not the default?!

let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-monokai

" .vimrc
" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details

" For multi-byte character support (CJK support, for example):
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1
       
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
 
set showcmd         " Show (partial) command in status line.

set number          " Show line numbers.

set showmatch       " When a bracket is inserted, briefly jump to the matching
                    " one. The jump is only done if the match can be seen on the
                    " screen. The time to show the match can be set with
                    " 'matchtime'.
 
set hlsearch        " When there is a previous search pattern, highlight all
                    " its matches.
 
set incsearch       " While typing a search command, show immediately where the
                    " so far typed pattern matches.
 
set ignorecase      " Ignore case in search patterns.
 
set smartcase       " Override the 'ignorecase' option if the search pattern
                    " contains upper case characters.
 
set backspace=2     " Influences the working of <BS>, <Del>, CTRL-W
                    " and CTRL-U in Insert mode. This is a list of items,
                    " separated by commas. Each item allows a way to backspace
                    " over something.
 
set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O"
                    " command).
 
"set textwidth=79    " Maximum width of text that is being inserted. A longer
                    " line will be broken after white space to get this width.
 
set formatoptions=c,q,r,t " This is a sequence of letters which describes how
                    " automatic formatting is to be done.
                    "
                    " letter    meaning when present in 'formatoptions'
                    " ------    ---------------------------------------
                    " c         Auto-wrap comments using textwidth, inserting
                    "           the current comment leader automatically.
                    " q         Allow formatting of comments with "gq".
                    " r         Automatically insert the current comment leader
                    "           after hitting <Enter> in Insert mode. 
                    " t         Auto-wrap text using textwidth (does not apply
                    "           to comments)
 
set ruler           " Show the line and column number of the cursor position,
                    " separated by a comma.
 
set background=dark " When set to "dark", Vim will try to use colors that look
                    " good on a dark background. When set to "light", Vim will
                    " try to use colors that look good on a light background.
                    " Any other value is illegal.
 
set mouse=a         " Enable the use of the mouse.

"set relativenumber  " change line numbers to relative

set t_Co=256        " Enable 256 colors

syntax on
