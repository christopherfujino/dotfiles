package api

import (
	"fmt"
	"log"
	"os"
	"strings"
)

var logFile *os.File

func print(v ...any) {
	var buffer = strings.Builder{}
	for _, v := range v {
		buffer.WriteString(fmt.Sprintf("%v", v))
		buffer.WriteString(", ")
	}
	buffer.WriteString("\n")
	if logFile != nil {
		logFile.WriteString(buffer.String())
	}
	log.Println(v...)
}

func getPlugins(plugins []string) string {
	var buffer = strings.Builder{}

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


