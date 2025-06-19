package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/neovim/go-client/nvim"
)

var logFile *os.File

func print(v ...any) {
	var buffer = strings.Builder{}
	for _, v := range v {
		buffer.WriteString(fmt.Sprintf("%v", v))
		buffer.WriteString(", ")
	}
	buffer.WriteString("\n")
	logFile.WriteString(buffer.String())
	log.Println(v...)
}

func check2[T any](t T, e error) T {
	check1(e)
	return t
}

func check1(e error) {
	if e != nil {
		print("Panic-ing!")
		print(e)
		panic(e)
	}
}

func setOption(client *nvim.Nvim, name string, value interface{}) {
	check1(client.SetOptionValue(name, value, map[string]nvim.OptionValueScope{}))
}

func main() {
	// TODO make this a stable path
	logFile = check2(os.Create("/home/chris/git/dotfiles/nvim-client/client.log"))
	defer logFile.Close()

	print("Go entrypoint")

	var reader = os.Stdin
	var writer = os.Stdout
	var closer = os.Stdout
	var client = check2(nvim.New(reader, writer, closer, log.Printf))
	print("Spawned client")
	check1(client.RegisterHandler("init", func(c *nvim.Nvim, args []string) (v int, err error) {
		v = 42
		defer (func() {
			maybe_err := recover()
			if maybe_err != nil {
				print("recovered from panic")
				err = maybe_err.(error)
				print("recovered: ")
				print(err)
				v = 0
			}
		})()
		print("Handled init RPC call")
		setOption(c, "number", true)
		setOption(c, "tabstop", 2)
		setOption(c, "shiftwidth", 2)
		setOption(c, "expandtab", true)
		setOption(c, "list", true)
		setOption(c, "termguicolors", true)
		setOption(c, "laststatus", 2)

		// Better splits
		setOption(c, "splitbelow", true)
		setOption(c, "splitright", true)

		// Disable netrw banner
		check1(c.SetVar("netrw_banner", false))

		check1(c.Command("colorscheme base16-eighties"))

		// Key bindings
		var noremap = map[string]bool{"noremap": true}
		check1(c.SetKeyMap("n", "<c-p>", ":Files<cr>", noremap))
		check1(c.SetKeyMap("n", "<c-t>", ":tabe<cr>", noremap))

		// Auto-commands
		check1(c.Command("autocmd FileType python set shiftwidth=4 tabstop=4"))
		check1(c.Command("autocmd FileType cs set shiftwidth=4 tabstop=4"))
		check1(c.Command("autocmd FileType go set noexpandtab nosmarttab"))
		check1(c.Command("autocmd FileType markdown set linebreak"))

		//vim.api.nvim_create_user_command(
		//	'NVimrc',
		//	function(opts)
		//		if vim.fn.has("win32") == 1 then
		//			vim.cmd("edit ~\\AppData\\Local\\nvim\\init.lua")
		//		else
		//			vim.cmd("edit ~/.config/nvim/init.lua")
		//		end
		//	end,
		//	{}
		//)

		return v, err
	}))
	check1(client.Serve())
}
