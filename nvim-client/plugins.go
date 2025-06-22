package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/neovim/go-client/nvim"
)

func bootstrapPlugins(c *nvim.Nvim) {
	var s string
	check1(c.ExecLua("return vim.fn.stdpath('data')", &s, nil))
	if s == "" {
		print("nothing was delivered")
		panic("failed to get neovim's data path")
	}
	s = fmt.Sprintf("%s/lazy/lazy.nvim", s)
	var _, err = os.Stat(s)
	if err != nil {
		var msg = fmt.Sprintf("Expected %s to exist, but it did not!\nCreate it with the command: `git clone https://github.com/folke/lazy.nvim.git %s --branch=stable`", s, s)
		print(msg)
		panic(msg)
	}
	check1(c.ExecLua(fmt.Sprintf("vim.opt.rtp:prepend('%s')", s), nil, nil))

	check1(c.ExecLua(getPlugins(), nil, nil))
}

func getPlugins() string {
	var buffer = strings.Builder{}
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

	buffer.WriteString("require('lazy').setup({\n")

	for _, plugin := range plugins {
		buffer.WriteString("    '")
		buffer.WriteString(plugin)
		buffer.WriteString("',\n")
	}

	// add empty options
	buffer.WriteString("}, {})\n")

	return buffer.String()
}
