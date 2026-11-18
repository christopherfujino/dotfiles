# We need this because otherwise there is no *first* rule
all:V: \
	build/i3config \
	build/init.lua \
	build/tmux.conf \
	build/.alacritty.toml

build/%: templates/%.erb mkfile build.rb .colorscheme
	ruby ./build.rb templates/$stem.erb

# vim: ft=make
