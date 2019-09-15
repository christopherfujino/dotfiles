#
# ~/.bash_profile
#

# Note: on MacOS, Homebrew path should be set first in /etc/paths
if [ $(uname) == 'darwin' ] && [ -n "$TMUX" ] && [ -f /etc/profile ]; then
  export PATH=''
  . /etc/profile
fi

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
else
  echo "Warning: you don't have a ~/.bashrc file, and there is no configuration in ~/.bash_profile!"
fi

# Anything after here was auto-generated
