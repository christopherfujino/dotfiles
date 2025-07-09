package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/neovim/go-client/nvim"
)

func setOption(client *nvim.Nvim, name string, value interface{}) {
	check1(client.SetOptionValue(name, value, map[string]nvim.OptionValueScope{}))
}

func setup() {
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
		logFile = check2(os.Create(path))
	}
}

func main() {
	setup()
	print("Go entrypoint")

	var reader = os.Stdin
	var writer = os.Stdout
	var closer = os.Stdout
	var client = check2(nvim.New(reader, writer, closer, log.Printf))
	print("Spawned client")
	check1(client.RegisterHandler("noop", func(c *nvim.Nvim, args []string) (string, error) {
		return "noop", nil
	}))
	check1(client.RegisterHandler("die", func(c *nvim.Nvim, args []string) {
		go (func() {
			print("About to sleep for 1 second")
			time.Sleep(time.Second)
			print("Exiting after sleep")
			os.Exit(0)
		})()
	}))
	check1(client.RegisterHandler("init", func(c *nvim.Nvim, args []string) (v string, err error) {
		v = "Success from Go"
		defer (func() {
			maybe_err := recover()
			if maybe_err != nil {
				print("recovered from panic")
				err = maybe_err.(error)
				print(err.Error())
				v = fmt.Sprintf("error from Go: %s", err.Error())
			}
		})()
		print("Handled init RPC call")

		chris(c)

		return v, err
	}))
	check1(client.Serve())
}
