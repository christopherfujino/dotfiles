#!/usr/bin/env ruby

# https://docs.ruby-lang.org/en/3.4/ERB.html
require 'erb'

src = "#{__dir__}/tmux.erb"
output = File.open("#{__dir__}/tmux.conf", 'w', 0644)

template = ERB.new IO.read(src)

output.write(template.result(binding))
output.close()
