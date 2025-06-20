package main

import (
	"fmt"
	"log"
	"os"
	"runtime"
	"strings"

	"github.com/neovim/go-client/nvim"
)

var logFile *os.File

func print(v ...any) {
	if logFile == nil {
		return
	}

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

		// Key bindings
		var noremap = map[string]bool{"noremap": true}
		check1(c.SetKeyMap("n", "<c-p>", ":Files<cr>", noremap))
		check1(c.SetKeyMap("n", "<c-t>", ":tabe<cr>", noremap))

		// For fzf.vim
		// Use rip grep for finding files, respect .gitignore
		// but also search "hidden" files, starting with dot
		c.Call("setenv", nil, "FZF_DEFAULT_COMMAND", "rg --files --hidden")

		// LSP Key bindings
		// Diagnostics
		// TODO need silent=true?
		var noremapsilent = map[string]bool{"noremap": true, "silent": true}
		check1(c.SetKeyMap("n", "<space>e", ":lua vim.diagnostic.open_float()<cr>", noremapsilent))
		check1(c.SetKeyMap("n", "<space>q", ":lua vim.diagnostic.setloclist()<cr>", noremapsilent))

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
