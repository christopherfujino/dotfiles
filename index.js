#!/usr/bin/env node

let fs = require('fs')
let dotfiles = {}

fs.readFile('inventory.json', 'utf8', installer)

function menu () {
  console.log('\n' + splash('Welcome To Chris\' Dotfiles Installer'))
  dotfiles.forEach(function (dotfile, i) {
    let check = ' '
    if (dotfile.checked) {check = 'x'}
    console.log(`${i}. ${dotfile.name} [${check}]`)
  })
}

function installer (err, data) {
  if (err) throw err
  dotfiles = JSON.parse(data).dotfiles
  menu()
}

function splash (string) {
  let topBottom = ''
  for (let i = 0; i < string.length + 4; i++) {
    topBottom += '*'
  }
  return `${topBottom}\n* ${string} *\n${topBottom}\n`
}

let stdin = process.openStdin()
stdin.on('data', function (chunk) {
  chunk = +chunk
  if (isNaN(chunk) || chunk >= dotfiles.length) return
  dotfiles[chunk].checked = !dotfiles[chunk].checked
  menu()
})
