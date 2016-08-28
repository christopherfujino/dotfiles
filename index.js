#!/usr/bin/env node

let fs = require('fs')
let dotfiles = {}
let {exec} = require('child_process')
let {platform} = require('os')

fs.readFile('inventory.json', 'utf8', installer)

function menu () {
  console.log('\033[2J\033c')
  console.log(splash('Welcome To Chris\' Dotfiles Installer'))
  dotfiles.forEach(function (dotfile, i) {
    if (dotfile.platform === 'any' || dotfile.platform === platform()) {
      let check = ' '
      if (dotfile.checked) {check = 'x'}
      console.log(`${i}. ${dotfile.name} [${check}]`)
    }
  })
  console.log('\nType number to select/unselect dotfile, [q] to quit, [i] to install:')
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
  if (('' + chunk)[0] === 'q') {
    console.log('Exiting without installing dotfiles.')
    process.exit(0)
  }
  if (('' + chunk)[0] === 'i') {
    console.log('install!')
    return
  }
  chunk = +chunk
  if (isNaN(chunk) || chunk >= dotfiles.length) return
  dotfiles[chunk].checked = !dotfiles[chunk].checked
  menu()
})
