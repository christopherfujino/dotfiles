package main

import (
	"fmt"
	"log"
	"os"
	"runtime"

	"github.com/neovim/go-client/nvim"
)

func setOption(client *nvim.Nvim, name string, value interface{}) {
	check1(client.SetOptionValue(name, value, map[string]nvim.OptionValueScope{}))
}

func main() {
	// TODO make this a stable path
	// TODO only create this file if in debug mode
	logFile = check2(os.Create("/home/chris/git/dotfiles/nvim-client/client.log"))
	defer logFile.Close()

	print("Go entrypoint")

	var reader = os.Stdin
	var writer = os.Stdout
	var closer = os.Stdout
	var client = check2(nvim.New(reader, writer, closer, log.Printf))
	print("Spawned client")
	check1(client.RegisterHandler("init", func(c *nvim.Nvim, args []string) (v string, err error) {
		v = "Success from Go"
		defer (func() {
			maybe_err := recover()
			if maybe_err != nil {
				print("recovered from panic")
				err = maybe_err.(error)
				print("recovered: ")
				print(err.Error())
				v = fmt.Sprintf("error from Go: %s", err.Error())
			}
		})()
		print("Handled init RPC call")
		setOption(c, "number", true)
		setOption(c, "tabstop", 2)
		setOption(c, "shiftwidth", 2)
		setOption(c, "expandtab", true)
		setOption(c, "signcolumn", "yes")   // Always show sign column, for gitdiff
		setOption(c, "list", true)          // Show trailing whitespace
		setOption(c, "termguicolors", true) // Otherwise WSL gets messed up
		setOption(c, "ignorecase", true)    // case insensitive search...
		setOption(c, "smartcase", true)     // ...unless you use a capital letter
		setOption(c, "laststatus", 2)       // Always show status bar

		// Better splits
		setOption(c, "splitbelow", true)
		setOption(c, "splitright", true)

		// Disable netrw banner
		check1(c.SetVar("netrw_banner", false))

		check1(c.Command("colorscheme base16-eighties"))

		// FZF
		var noremap = map[string]bool{"noremap": true}
		check1(c.SetKeyMap("n", "<c-p>", ":Files<cr>", noremap))
		check1(c.SetKeyMap("n", "<c-t>", ":tabe<cr>", noremap))

		// Use rip grep for finding files, respect .gitignore
		// but also search "hidden" files, starting with dot
		check1(c.Call("setenv", nil, "FZF_DEFAULT_COMMAND", "rg --files --hidden"))

		// LSP Setup
		lspSetup(c)

		// Disable middle-mouse paste
		for _, mode := range [3]string{"n", "v", "i"} {
			check1(c.SetKeyMap(mode, "<MiddleMouse>", "<Nop>", noremap))
			check1(c.SetKeyMap(mode, "<2-MiddleMouse>", "<Nop>", noremap))
			check1(c.SetKeyMap(mode, "<3-MiddleMouse>", "<Nop>", noremap))
			check1(c.SetKeyMap(mode, "<4-MiddleMouse>", "<Nop>", noremap))
		}

		// Auto-commands
		check1(c.Command("autocmd FileType python set shiftwidth=4 tabstop=4"))
		check1(c.Command("autocmd FileType cs set shiftwidth=4 tabstop=4"))
		check1(c.Command("autocmd FileType go set noexpandtab nosmarttab"))
		check1(c.Command("autocmd FileType markdown set linebreak"))

		var cmd nvim.UserVimCommand = "edit ~/.config/nvim/init.lua"
		if runtime.GOOS == "windows" {
			cmd = "edit ~\\AppData\\Local\\nvim\\init.lua"
		}
		c.CreateUserCommand("NVimrc", cmd, map[string]any{})

		// This includes the newline
		c.SetVar("goyo_width", 81)

		check1(c.ExecLua("require('nvim-autopairs').setup {disable_filetype = {}}", nil, nil))

		return v, err
	}))
	check1(client.Serve())
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

	var lspServers = []string{
		// go install golang.org/x/tools/gopls@latest
		"clangd",
		"dartls",
		"gopls",
		"ocamllsp",
		// gem install --user-install ruby-lsp
		"ruby_lsp",
		"ts_ls",
	}
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

	//check1(c.SetKeyMap("n", "[d", ":lua vim.diagnostic.goto_prev()<cr>", noremapsilent))
	//check1(c.SetKeyMap("n", "]d", ":lua vim.diagnostic.goto_next()<cr>", noremapsilent))
	check1(c.SetKeyMap("n", "<space>e", ":lua vim.diagnostic.open_float()<cr>", noremapsilent))
	check1(c.SetKeyMap("n", "<space>q", ":lua vim.diagnostic.setloclist()<cr>", noremapsilent))
}
