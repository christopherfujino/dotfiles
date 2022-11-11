" Christopher Fujino's init.vim
"   For use in NeoVim > 0.7.0

" System Setup
syntax on
filetype plugin indent off
set encoding=utf-8
scriptencoding utf-8
" for lang client
set hidden

" Without this, colors are wack in WSL
set termguicolors

set autoread
set signcolumn=yes  " Always draw sign column
set noshowmode      " Unneccessary since we use airline
set list            " Highlight trailing whitespace
"set textwidth=80    " Maximum width of insert text
"set colorcolumn=+1  " Highlight column 1 after textwidth

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

" Mouse - don't paste on middle mouse
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

  " NeoVim!
  if has('nvim')
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-path'
    Plug 'mfussenegger/nvim-dap'
  endif

  Plug 'dart-lang/dart-vim-plugin'

  " Typescript Support
  Plug 'leafgarland/typescript-vim'

  " better js syntax
  Plug 'yuezk/vim-js'

  " Add JSX Syntax
  "Plug 'MaxMEllon/vim-jsx-pretty'

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

  "Plug 'edkolev/tmuxline.vim'

  " Distraction free mode
  Plug 'junegunn/goyo.vim'

  " Search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call plug#end()

filetype plugin indent on

" PLUGIN VARIABLES
colorscheme base16-monokai



" Vim-Airline Theming
let g:airline_theme='base16_monokai'
let g:airline_powerline_fonts=1
"let g:airline#extensions#tabline#enabled = 1
let g:airline_section_b='' " don't show git branch

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" the default was not implemented by mononoki
" See :help airline-customization for all mappings
let g:airline_symbols.colnr = ' #'

let g:goyo_width=81

" yggdroot/indentLine
let g:indentLine_char = '⎸'
let g:indentLine_bufNameExclude = ["term:.*"] " Don't show in terminal!
let g:indentLine_setConceal = 0 " This was hiding quotes in JSON files

" Dart Style Guide - for vim-dart
let g:dart_style_guide = 2

" FZF Magic
let g:fzf_commits_log_options = '--graph --color=always --all --format="%C(auto)%h %C(black)%C(bold)%cr%C(auto)%d %C(reset)%s"'
let $FZF_DEFAULT_COMMAND='rg --files'
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

function! s:format()
  let ft = &filetype
  " Ampersand captures setting value
  if ft == 'python'
    :% ! yapf --style=chromium
  else
    echoerr 'Unimplemented s:format() func for &ft == ' . ft
  endif
endfunction

command Format call s:format()

command! EVimrc edit ~/.vimrc
command! NVimrc edit ~/.config/nvim/init.vim

" Execute (!) current file (%) with full path (:p)
command! Execute :! %:p

command! Diffs
      \ call fzf#run({
      \   'source': "git diff --stat | awk '{print $1}' | sed '$ d'",
      \   'sink': 'edit'
      \})

nnoremap <c-t> :tabe<cr>

" If starting vim with a directory as first (and only) arg, cd into dir
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) | execute 'cd' argv()[0] | endif

" nvim-lspconfig
lua <<EOF
  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  --vim.lsp.set_log_level("ERROR")
  -- Add additional capabilities supported by nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  -- Lua ternary hack: http://lua-users.org/wiki/TernaryOperator
  local dartBinary = (vim.fn.has('win32') == 1) and 'dart.bat' or 'dart'
  require('lspconfig').dartls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
    -- for context https://github.com/dart-lang/sdk/issues/49157
    cmd = {dartBinary, 'language-server', '--protocol=lsp'},
    root_dir = require('lspconfig.util').root_pattern('pubspec.yaml', 'dartdoc_options.yaml'),
    init_options = {
      -- When set to true, workspace folders will be ignored and analysis will be performed based on the open files, as if no workspace was open at all. This allows opening large folders without causing them to be completely analyzed. Defaults to false.
      onlyAnalyzeProjectsWithOpenFiles = true,
      -- When set to false, completion will not include synbols that are not already imported into the current file. Defaults to true, though the client must additionally support workspace/applyEdit for these completions to be included.
      suggestFromUnimportedLibraries = true,
      closingLabels = true,
      outline = true,
      flutterOutline = true,
    },
  }

  require('lspconfig').gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
  }

  require('lspconfig').tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- local root_files = {
  --   '.clangd',
  --   '.clang-tidy',
  --   '.clang-format',
  --   'compile_commands.json',
  --   'compile_flags.txt',
  --   'configure.ac', -- AutoTools
  -- }
  require('lspconfig').clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- https://github.com/regen100/cmake-language-server
  -- local root_files = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' }
  require('lspconfig').cmake.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- nvim-cmp setup
  local cmp = require 'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
        local indent = string.match(line_text, '^%s*')
        local replace = vim.split(args.body, '\n', true)
        local surround = string.match(line_text, '%S.*') or ''
        local surround_end = surround:sub(col)

        replace[1] = surround:sub(0, col - 1)..replace[1]
        replace[#replace] = replace[#replace]..(#surround_end > 1 and ' ' or '')..surround_end
        if indent ~= '' then
          for i, line in ipairs(replace) do
            replace[i] = indent..line
          end
        end

        vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        --elseif luasnip.expand_or_jumpable() then
        --  luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        --elseif luasnip.jumpable(-1) then
        --  luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    },{
      { name = 'path' },
      --{ name = 'luasnip' },
    }),
  }

  -- Debug Adapter
  -- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt

  local dap = require('dap')

  dap.adapters.dart = {
    type = "executable",
    command = "dart",
    args = {"debug_adapter"}
  }
  dap.configurations.dart = {
    {
      type = "dart",
      request = "launch",
      name = "Launch Dart Program",
      program = "${workspaceFolder}/bin/flutter_tools.dart",
      cwd = "${workspaceFolder}",
      args = {"doctor", "-v"},
    }
  }

  -- See :help dap-widgets
  local cmd = vim.api.nvim_create_user_command
  local widgets = require('dap.ui.widgets')
  -- widgets.sidebar could be widgets.centered_float
  cmd(
    'DapShowScopes',
    function()
      widgets.sidebar(widgets.scopes).open()
    end,
    {}
  )
  cmd(
    'DapShowFrames',
    function()
      widgets.sidebar(widgets.frames).open()
    end,
    {}
  )
EOF

if has('win32')
  command! Powershell edit term://powershell
endif

autocmd BufWritePost init.vim :so %

" Syntaxes
"autocmd FileType python set sw=4 tw=4 # this was causing weird newlines
"autocmd FileType cs set sw=4 tw=4
