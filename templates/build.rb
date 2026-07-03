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

def make_colorscheme(name, colors)
  unless colors.length == 16
    raise 'flooboo'
  end
  h = {colorscheme_name: name}

  colors.each_with_index do |color, i|
    code = i.to_s(base=16).upcase
    h["base0#{code}"] = color
    h["base0#{code}_h"] = "##{color}"
  end

  h
end

deps = [
  'init.lua.erb', # symlink to $HOME/.config/nvim/init.lua
  'tmux.conf.erb', # symlink to $HOME/.tmux.conf
  'i3config.erb', # symlink to $HOME/.i3/config
]

# https://github.com/joshwlewis/base16-unikitty/blob/82aae2af20668ab56a49434c0db80b88f416c67e/unikitty-light.yaml
vars = make_colorscheme(
  'base16-unikitty-light',
  [
    "ffffff", # base00 - Default Background
    "e1e1e2", # base01 - Lighter Background (Used for status bars, line number and folding marks)
    "c4c3c5", # base02 - Selection Background
    "a7a5a8", # base03 - Comments, Invisibles, Line Highlighting
    "89878b", # base04 - Dark Foreground (Used for status bars)
    "6c696e", # base05 - Default Foreground, Caret, Delimiters, Operators
    "4f4b51", # base06 - Light Foreground (Not often used)
    "322d34", # base07 - Light Background (Not often used)
    "d8137f", # base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    "d65407", # base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
    "dc8a0e", # base0A - Classes, Markup Bold, Search Text Background
    "17ad98", # base0B - Strings, Inherited Class, Markup Code, Diff Inserted
    "149bda", # base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
    "775dff", # base0D - Functions, Methods, Attribute IDs, Headings
    "aa17e6", # base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
    "e013d0", # base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  ],
)

p vars

build deps, vars, "#{__dir__}/../build"
