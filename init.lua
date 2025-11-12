-- See legacy version with:
-- git show ee1033606fd2cc9f3c479644135799f4b0fde6ee:init.lua

-- general
vim.opt.list = true
vim.opt.laststatus = 2
vim.g.netrw_banner =  false

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- ruler
vim.opt.rulerformat = "%-10.(%l,%c%V%)"

-- better splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- 24-bit color (inherit term colors)
vim.opt.termguicolors = true --?

-- disable middle mouse paste
for bindingPrefix in ipairs({"", "2-", "3-", "4-"}) do
  vim.keymap.set({"n", "v", "i"}, "<" .. bindingPrefix .. "MiddleMouse", "<Nop>", {noremap=true})
end

vim.keymap.set("n", "<c-p>", ":Files<cr>", {noremap=true})
vim.keymap.set("n", "<c-t>", ":tabe<cr>", {noremap=true})

-- Plugins TODO: deprecate
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
  -- plugins
  {
    "neovim/nvim-lspconfig",
    --"mfussenegger/nvim-dap",
    -- :Rename, :Move, :Delete
    "tpope/vim-eunuch",
    -- cs'"
    "tpope/vim-surround",
    -- auto-bracket pairing
    "windwp/nvim-autopairs",

    -- git
    'tpope/vim-fugitive',

    'junegunn/fzf',
    'junegunn/fzf.vim',
  },
  -- options
  {}
)

vim.fn.setenv("FZF_DEFAULT_COMMAND", "rg --files --hidden")

-- LSP
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  -- Will jump to interface files in OCaml
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format {async = true } end, bufopts)
end

-- go install golang.org/x/tools/gopls@latest
require('lspconfig').gopls.setup {
  on_attach = on_attach,
}

require('lspconfig').ocamllsp.setup {
  on_attach = on_attach,
  filetypes = { 'ocaml' },
  root_dir = require('lspconfig.util').root_pattern('*.opam'),
}

require('lspconfig').clangd.setup {
  on_attach = on_attach,
}
