package main

import (
	"runtime"

	"github.com/neovim/go-client/nvim"
)

func chris(c *nvim.Nvim) {
	setOption(c, "number", true)
	setOption(c, "tabstop", 2)
	setOption(c, "shiftwidth", 2)
	setOption(c, "expandtab", true)
	setOption(c, "signcolumn", "yes")   // Always show sign column, for gitdiff
	setOption(c, "list", false)         // Do NOT show trailing whitespace
	setOption(c, "termguicolors", true) // Otherwise WSL gets messed up
	setOption(c, "ignorecase", true)    // case insensitive search...
	setOption(c, "smartcase", true)     // ...unless you use a capital letter
	setOption(c, "laststatus", 2)       // Always show status bar

	// Better splits
	setOption(c, "splitbelow", true)
	setOption(c, "splitright", true)

	// Disable netrw banner
	check1(c.SetVar("netrw_banner", false))

	var noremap = map[string]bool{"noremap": true}

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

	bootstrapPlugins(c,
		[]string{
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
		},

		func() {
			check1(c.Command("colorscheme base16-eighties"))

			// FZF
			check1(c.SetKeyMap("n", "<c-p>", ":Files<cr>", noremap))
			check1(c.SetKeyMap("n", "<c-t>", ":tabe<cr>", noremap))

			// Use rip grep for finding files, respect .gitignore
			// but also search "hidden" files, starting with dot
			check1(c.Call("setenv", nil, "FZF_DEFAULT_COMMAND", "rg --files --hidden"))

			// LSP Setup
			lspSetup(c)

			// This includes the newline
			c.SetVar("goyo_width", 81)

			check1(c.ExecLua("require('nvim-autopairs').setup {disable_filetype = {}}", nil, nil))
		})
}
