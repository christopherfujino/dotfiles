#!/usr/bin/env node

let fs = require('fs')

fs.readFile('inventory.json', 'utf8', installer)

function installer (err, data) {
  if (err) throw err
  let dotfiles = JSON.parse(data).dotfiles

  console.log('\n' + splash('Welcome To Chris\' Dotfiles Installer'))
  dotfiles.forEach(function (dotfile, i) {
    console.log(`${i}. ${dotfile.name}`)
  })
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
})
