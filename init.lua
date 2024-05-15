---- Experimental

-- options
vim.opt.number = true
vim.opt.tabstop = 2        -- Width of a <tab>
vim.opt.shiftwidth = 2     -- Number of spaces to use for each step of auto-indent
vim.opt.expandtab = true   -- Use the appropriate number of spaces to insert a tab
vim.opt.signcolumn = "yes" -- always draw sign column
vim.opt.list = true        -- show "-" for trailing whitespace, ">" for tab

-- better splits
vim.opt.splitbelow = true
vim.opt.splitright = true

---- mappings

-- disable middle mouse paste
vim.keymap.set({"n", "v", "i"}, "<MiddleMouse>", "<Nop>", {noremap=true})
vim.keymap.set({"n", "v", "i"}, "<2-MiddleMouse>", "<Nop>", {noremap=true})
vim.keymap.set({"n", "v", "i"}, "<3-MiddleMouse>", "<Nop>", {noremap=true})
vim.keymap.set({"n", "v", "i"}, "<4-MiddleMouse>", "<Nop>", {noremap=true})

vim.keymap.set("n", "<c-p>", ":Files<cr>", {noremap=true})

---- plugins

--bootstrap lazy.nvim
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
    -- Chris Kempson's Base16 colorschemes, see `colorscheme...`
    "chriskempson/base16-vim",

    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    -- Shows git diff in gutter
    "airblade/vim-gitgutter",
    -- :Rename, :Move, :Delete
    "tpope/vim-eunuch",
    -- cs'"
    "tpope/vim-surround",
    -- auto-bracket pairing
    "windwp/nvim-autopairs",

    -- auto-complete
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",

    -- git
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    'junegunn/fzf',
    'junegunn/fzf.vim',
  },
  -- options
  {}
)

vim.cmd.colorscheme("base16-eighties")

require("nvim-autopairs").setup {
  disable_filetype = {},
}

-- lsp
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

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format {async = true } end, bufopts)
end
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local dartBinary
if vim.fn.has('win32') == 1 then
  dartBinary = 'dart.bat'
else
  dartBinary = 'dart'
end

require('lspconfig').dartls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = require('lspconfig.util').root_pattern('pubspec.yaml', 'dartdoc_options.yaml'),
  -- https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server/tool/lsp_spec/README.md
  init_options = {
    -- When set to true, workspace folders will be ignored and analysis will be performed based on the open files, as if no workspace was open at all. This allows opening large folders without causing them to be completely analyzed. Defaults to false.
    onlyAnalyzeProjectsWithOpenFiles = true,
    -- When set to false, completion will not include symbols that are not already imported into the current file. Defaults to true, though the client must additionally support workspace/applyEdit for these completions to be included.
    suggestFromUnimportedLibraries = true,
    closingLabels = true,
    outline = true,
    flutterOutline = true,
    showTodos = false,
    -- Whether to include code snippets (such as class, stful, switch) in code completion. When unspecified, snippets will be included.
    enableSnippets = false,
  },
}

-- Auto-complete
local cmp = require 'cmp'
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  })
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
    program = "${workspaceFolder}/main.dart",
    cwd = "${workspaceFolder}",
    --args = {"run", "-d", "web-server"},
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
