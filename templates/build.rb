#!/usr/bin/env ruby

# https://docs.ruby-lang.org/en/3.4/ERB.html
require 'erb'

$re = /^(.*)\.erb$/

def build(deps, vars, out)
  def _build(vars, template)
    b = Kernel.binding
    vars.each_pair do |k, v|
      b.local_variable_set k, v
    end

    # TODO: catch and handle exceptions
    template.result(b)
  end

  unless Dir.exist? out
    puts "creating #{out}"
    Dir.mkdir(out, 0755)
  end

  deps.each do |dep|
    puts "Compiling #{dep}..."

    target_relative_path = $re.match(dep).captures[0]
    target_path = "#{out}/#{target_relative_path}"
    # TODO check if target exists and is up to date
    target = File.open(target_path, 'w', 0644)

    template = ERB.new IO.read("#{__dir__}/#{dep}")

    compiled_template = _build(vars, template)

    target.write(compiled_template)
    target.close()  
  end
end

deps = [
  'init.lua.erb', # symlink to $HOME/.config/nvim/init.lua
  'tmux.conf.erb', # symlink to $HOME/.tmux.conf
]

vars = {
  colorscheme_name: 'base16-unikitty-light',
  base00: "#ffffff", # Base 00 - Black
  base03: "#a7a5a8", # Base 03 - Bright Black
  base05: "#6c696e", # Base 05 - White
  base07: "#322d34", # Base 07 - Bright White
  base0A: "#dc8a0e", # Base 0A - Bright Yellow
  base0B: "#17ad98", # Base 0B - Bright Green
  base0C: "#149bda", # Base 0C - Bright Cyan
}

build deps, vars, "#{__dir__}/../build"
