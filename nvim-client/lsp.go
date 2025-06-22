package main

import (
	"fmt"
	"github.com/neovim/go-client/nvim"
)

var lspServers = []string{
	// go install golang.org/x/tools/gopls@latest
	"clangd",

	// Dart customizations
	// require('lspconfig').dartls.setup {
	//   cmd = {"dart", "language-server", "--protocol=lsp"},
	//   on_attach = on_attach,
	//   -- https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server/tool/lsp_spec/README.md
	//   init_options = {
	//     -- When set to true, workspace folders will be ignored and analysis will be performed based on the open files, as if no workspace was open at all. This allows opening large folders without causing them to be completely analyzed. Defaults to false.
	//     onlyAnalyzeProjectsWithOpenFiles = true,
	//     -- When set to false, completion will not include symbols that are not already imported into the current file. Defaults to true, though the client must additionally support workspace/applyEdit for these completions to be included.
	//     suggestFromUnimportedLibraries = true,
	//     closingLabels = true,
	//     outline = true,
	//     flutterOutline = true,
	//   },
	//   settings = {
	//     dart = {
	//       showTodos = false,
	//       -- Whether to include code snippets (such as class, stful, switch) in code completion. When unspecified, snippets will be included.
	//       enableSnippets = false,
	//     },
	//   },
	// }
	"dartls",
	"gopls",
	"ocamllsp",
	// gem install --user-install ruby-lsp
	"ruby_lsp",
	"ts_ls",
}

func lspSetup(c *nvim.Nvim) {
	// Use an on_attach function to only map the following keys
	// after the language server attaches to the current buffer
	check1(c.ExecLua(`__on_attach = function(client, bufnr)
	-- Enable completion
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See ":help vim.lsp.*" for documentation on any of the below functions
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
end`, nil, nil))


	for _, server := range lspServers {
		print(server)
		check1(
			c.ExecLua(
				fmt.Sprintf(
					"require('lspconfig').%s.setup({on_attach = __on_attach})",
					server,
				),
				nil,
				nil,
			),
		)
	}
	// Diagnostics
	// TODO need silent=true?
	var noremapsilent = map[string]bool{"noremap": true, "silent": true}

	// Keymaps
	check1(c.SetKeyMap("n", "[d", ":lua vim.diagnostic.goto_prev()<cr>", noremapsilent))
	check1(c.SetKeyMap("n", "]d", ":lua vim.diagnostic.goto_next()<cr>", noremapsilent))
	check1(c.SetKeyMap("n", "<space>e", ":lua vim.diagnostic.open_float()<cr>", noremapsilent))
	check1(c.SetKeyMap("n", "<space>q", ":lua vim.diagnostic.setloclist()<cr>", noremapsilent))
}
