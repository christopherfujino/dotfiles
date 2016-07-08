" ~/.vimrc
"
" Christopher Fujino's .vimrc
" For use in Vim & NeoVim
"
" https://github.com/junegunn/vim-plug must be installed to manage plugins

set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

"Plug 'edkolev/tmuxline.vim'  " only necessary temporarily for sourcing /etc/tmux.conf

"let g:tmuxline_preset = {
"  \'a'    : "#(ip addr | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d '/' -f 1)",
"  \'win'  : ['#I', '#W'],
"  \'cwin' : ['#I', '#F#W'],
"  \'y'    : ['%a %b %d'],
"  \'z'    : '%r',
"  \'options': { 'status-justify': 'left'}}

Plug 'tpope/vim-fugitive'

" https://github.com/Shutnik/jshint2.vim
" Plug 'Shutnik/jshint2.vim'

" surround.vim

Plug 'tpope/vim-surround'

let jshint2_read = 1
let jshint2_save = 1

" Plug 'bling/vim-airline' vim status-line
Plug 'bling/vim-airline'

" Plug 'jiangmiao/auto-pairs' auto bracket pairing plugin
Plug 'jiangmiao/auto-pairs'

" The Nerd Tree: A tree explorer plugin for vim
Plug 'scrooloose/nerdtree'

" Quicktask: a lightweight Vim task management plugin
"Plug 'aaronbieber/vim-quicktask'

" show indentation markers
Plug 'yggdroot/indentLine'

" nerdtree-git-plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" Vim-gitgutter
Plug 'airblade/vim-gitgutter'

" Control-P fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'

let g:airline_powerline_fonts=1
set laststatus=2

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

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

"set showmatch       " When a bracket is inserted, briefly jump to the matching
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

set relativenumber  " change line numbers to relative

set t_Co=256        " Enable 256 colors
colorscheme monokai

filetype plugin indent on
syntax on
