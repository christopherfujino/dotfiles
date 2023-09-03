# To see where PS checks for this file, execute:
# `$profile`
#
# To symlink this to that path, start an admin command prompt, and execute:
# `mklink <DEST> <SRC>`

Set-Alias -Name g -Value git

# https://github.com/PowerShell/PSReadLine
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# You don't want an annoying beep each time you hit tab
Set-PSReadLineOption -BellStyle None

Set-PSReadLineOption -EditMode Emacs
