package api

import (
	"flag"
	"fmt"
	"log"
	"os"
	"runtime/debug"
	"time"

	"github.com/neovim/go-client/nvim"
)

func SetOption(client *nvim.Nvim, name string, value interface{}) {
	Check1(client.SetOptionValue(name, value, map[string]nvim.OptionValueScope{}))
}

func Setup(user func(*nvim.Nvim)) {
	var debug bool
	flag.BoolVar(&debug, "debug", false, "In debug mode, a log file is written to disk.")

	flag.Parse()

	if debug {
		path := os.Getenv("HOME")
		if len(path) == 0 {
			panic(
				"Cannot run chris-nvim-client in debug mode without a $HOME env var",
			)
		}
		path = fmt.Sprintf("%s/.chris-nvim-client.log", path)
		logFile = Check2(os.Create(path))
	}

	print("Go entrypoint")

	var reader = os.Stdin
	var writer = os.Stdout
	var closer = os.Stdout
	var client = Check2(nvim.New(reader, writer, closer, log.Printf))
	print("Spawned client")
	Check1(client.RegisterHandler("noop", func(c *nvim.Nvim, args []string) (string, error) {
		return "noop", nil
	}))
	Check1(client.RegisterHandler("die", func(c *nvim.Nvim, args []string) {
		go (func() {
			print("About to sleep for 1 second")
			time.Sleep(time.Second)
			print("Exiting after sleep")
			os.Exit(0)
		})()
	}))
	Check1(client.RegisterHandler("init", func(c *nvim.Nvim, args []string) (v string, err error) {
		v = "Success from Go"
		defer (func() {
			maybe_err := recover()
			if maybe_err != nil {
				print("recovered from panic")
				var msg string
				msg, ok := maybe_err.(string)
				if !ok {
					err, ok := maybe_err.(error)
					if !ok {
						msg = fmt.Sprintf("Panic'd unknown type: %v", maybe_err)
					} else {
						msg = err.Error()
					}
				}
				print(msg)
				v = fmt.Sprintf("error from Go: %s", msg)
			}
		})()
		print("Handled init RPC call")

		user(c)

		return v, err
	}))
	Check1(client.Serve())
}

func BootstrapPlugins(c *nvim.Nvim, plugins []string, after func()) {
	var s string
	Check1(c.ExecLua("return vim.fn.stdpath('data')", &s, nil))
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
	Check1(c.ExecLua(fmt.Sprintf("vim.opt.rtp:prepend('%s')", s), nil, nil))

	Check1(c.ExecLua(getPlugins(plugins), nil, nil))

	after()
}

// TODO rewrite this to :help vim.lsp.config()
func Lsp(c *nvim.Nvim, lsps []string) {
	// Use an on_attach function to only map the following keys
	// after the language server attaches to the current buffer
	Check1(c.ExecLua(`__on_attach = function(client, bufnr)
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

	for _, server := range lsps {
		print(server)
		Check1(
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
	Check1(c.SetKeyMap("n", "[d", ":lua vim.diagnostic.goto_prev()<cr>", noremapsilent))
	Check1(c.SetKeyMap("n", "]d", ":lua vim.diagnostic.goto_next()<cr>", noremapsilent))
	Check1(c.SetKeyMap("n", "<space>e", ":lua vim.diagnostic.open_float()<cr>", noremapsilent))
	Check1(c.SetKeyMap("n", "<space>q", ":lua vim.diagnostic.setloclist()<cr>", noremapsilent))
}

func Check2[T any](t T, e error) T {
	Check1(e)
	return t
}

func Check1(e error) {
	if e != nil {
		print(fmt.Sprintf("Panic-ing at %s!", debug.Stack()))
		print(e)
		panic(e)
	}
}

type CleanPane struct {
	top nvim.Buffer
	left nvim.Buffer
	right nvim.Buffer
	bottom nvim.Buffer
}

var localScope = map[string]nvim.OptionValueScope{
	"scope": nvim.LocalScope,
}

func initPad(c *nvim.Nvim, cmd string) nvim.Buffer {
	Check1(c.Command(cmd))
	buf := Check2(c.CurrentBuffer())
	Check1(c.SetOptionValue("buftype", "nofile", localScope))
	Check1(c.SetOptionValue("bufhidden", "wipe", localScope))
	Check1(c.SetOptionValue("modifiable", false, localScope))
	Check1(c.SetOptionValue("buflisted", false, localScope))
	Check1(c.SetOptionValue("swapfile", false, localScope))
	Check1(c.SetOptionValue("cursorline", false, localScope))
	Check1(c.SetOptionValue("cursorcolumn", false, localScope))
	Check1(c.SetOptionValue("statusline", "", localScope))

	return buf
}

func (cp *CleanPane) Init(c *nvim.Nvim) {
	cp.left = initPad(c, "vertical topleft new")
	cp.right = initPad(c, "vertical botright new")
	cp.top = initPad(c, "topleft new")
	cp.bottom = initPad(c, "botright new")

	cp.Resize(c)
}

func (cp *CleanPane) Resize(c *nvim.Nvim) {
	res := Check2(c.Exec(fmt.Sprintf("execute bufwinnr(%d)", cp.top), map[string]any{}))
	print(len(res))
}
