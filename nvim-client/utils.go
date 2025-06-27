package main

import (
	"runtime/debug"
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

func check2[T any](t T, e error) T {
	check1(e)
	return t
}

func check1(e error) {
	if e != nil {
		print(fmt.Sprintf("Panic-ing at %s!", debug.Stack()))
		print(e)
		panic(e)
	}
}


