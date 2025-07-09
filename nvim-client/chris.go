package main

import (
	"runtime"

	"github.com/christopherfujino/nvim-client/api"
	"github.com/neovim/go-client/nvim"
)

var plugins = []string{
	"RRethy/base16-nvim",

	"neovim/nvim-lspconfig",
	"mfussenegger/nvim-dap",
	// Shows git diff in gutter
	"airblade/vim-gitgutter",
	// :Rename, :Move, :Delete
	"tpope/vim-eunuch",
	// cs'"
	"tpope/vim-surround",
	// auto-bracket pairing
	"windwp/nvim-autopairs",

	// git
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	"junegunn/fzf",
	"junegunn/fzf.vim",

	"junegunn/goyo.vim",
}

var lspServers = []string{
	// go install golang.org/x/tools/gopls@latest
	"clangd",

	// See christopherfujino/dotfiles@8b0006ff8b24864348ebb535b5931cf812965a3f
	// for fine-grained Dart LSP config
	"dartls",
	"gopls",
	"ocamllsp",
	// gem install --user-install ruby-lsp
	"ruby_lsp",
	"ts_ls",
}

func main() {
	api.Setup(
		func(c *nvim.Nvim) {
			api.SetOption(c, "number", true)
			api.SetOption(c, "tabstop", 2)
			api.SetOption(c, "shiftwidth", 2)
			api.SetOption(c, "expandtab", true)
			api.SetOption(c, "signcolumn", "yes")   // Always show sign column, for gitdiff
			api.SetOption(c, "list", false)         // Do NOT show trailing whitespace
			api.SetOption(c, "termguicolors", true) // Otherwise WSL gets messed up
			api.SetOption(c, "ignorecase", true)    // case insensitive search...
			api.SetOption(c, "smartcase", true)     // ...unless you use a capital letter
			api.SetOption(c, "laststatus", 2)       // Always show status bar

			// Better splits
			api.SetOption(c, "splitbelow", true)
			api.SetOption(c, "splitright", true)

			// Disable netrw banner
			api.Check1(c.SetVar("netrw_banner", false))

			var noremap = map[string]bool{"noremap": true}

			// Disable middle-mouse paste
			for _, mode := range [3]string{"n", "v", "i"} {
				api.Check1(c.SetKeyMap(mode, "<MiddleMouse>", "<Nop>", noremap))
				api.Check1(c.SetKeyMap(mode, "<2-MiddleMouse>", "<Nop>", noremap))
				api.Check1(c.SetKeyMap(mode, "<3-MiddleMouse>", "<Nop>", noremap))
				api.Check1(c.SetKeyMap(mode, "<4-MiddleMouse>", "<Nop>", noremap))
			}

			// Auto-commands
			api.Check1(c.Command("autocmd FileType python set shiftwidth=4 tabstop=4"))
			api.Check1(c.Command("autocmd FileType cs set shiftwidth=4 tabstop=4"))
			api.Check1(c.Command("autocmd FileType go set noexpandtab nosmarttab"))
			api.Check1(c.Command("autocmd FileType markdown set linebreak"))

			var cmd nvim.UserVimCommand = "edit ~/.config/nvim/init.lua"
			if runtime.GOOS == "windows" {
				cmd = "edit ~\\AppData\\Local\\nvim\\init.lua"
			}
			c.CreateUserCommand("NVimrc", cmd, map[string]any{})

			api.BootstrapPlugins(c,
				plugins,

				func() {
					api.Check1(c.Command("colorscheme base16-eighties"))

					// FZF
					api.Check1(c.SetKeyMap("n", "<c-p>", ":Files<cr>", noremap))
					api.Check1(c.SetKeyMap("n", "<c-t>", ":tabe<cr>", noremap))

					// Use rip grep for finding files, respect .gitignore
					// but also search "hidden" files, starting with dot
					api.Check1(c.Call("setenv", nil, "FZF_DEFAULT_COMMAND", "rg --files --hidden"))

					// LSP Setup
					api.Lsp(c, lspServers)

					// This includes the newline
					c.SetVar("goyo_width", 81)

					api.Check1(c.ExecLua("require('nvim-autopairs').setup {disable_filetype = {}}", nil, nil))
				})
		},
	)
}
