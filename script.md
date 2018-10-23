# Vim: An Exciting New JS IDE

## Why You Should Use Vim...

This post assumes you already know that Vim has the greatest UI ever invented.
If you're not sure why a programmer would use Vim as their full-time editor,
just do a youtube search on Vim. There are many, many great talks and blog
posts about switching to Vim, and the benefits it brings. This is not that
article.

## A Brief History of Tools

The first programming language I learned was BASIC on an Apple II GS. It
didn't have a hard drive, and booted directly into a BASIC prompt. Every time
I wanted to write a line of code, I began by typing in the line number,
followed by a space and then the code, ala: `10 PRINT "HELLO, WORLD"`. If I
wanted to edit that line, I simply overwrote the same line.

## 60-second Vim Tutorial

1. Vim is a modal editor
2. The two modes you need to know today are *normal* and *insert*
3. From *normal* mode, enter *insert* mode by pressing `i`
4. From any mode, return to *normal* mode by pressing `esc`
5. In *insert* mode, you can edit text as you're used to
6. In *normal* mode, you enter commands by prefixing them with a `:`
7. save current buffer with `:w <filename>`
8. If the file is already named, you can save with just `:w`
9. If the file is saved, exit vim with `:q`
10. If file is unsaved, but you would like to exit anyway, `:q!`
