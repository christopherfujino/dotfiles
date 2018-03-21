#
# ~/.bash_profile
#

if [ -n "$TMUX" ] && [ -f /etc/profile ]; then
  export PATH=''
  . /etc/profile
fi

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
else
  echo "Warning: you don't have a ~/.bashrc file, and there is no configuration in ~/.bash_profile!"
fi
