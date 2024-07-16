#!/usr/bin/env ruby

require 'date'

home = ENV['HOME']
raise 'You do not have a $HOME env var set' if home.nil?
tmp = "#{home}/tmp"
unless Dir.exists? tmp
  puts "Creating temp dir at #{tmp}..."
  Dir.mkdir tmp
end

filename = "#{DateTime.now.strftime('%Y-%m-%d-%H:%M')}-screenshot.png"
output = "#{tmp}/#{filename}"

result = Kernel.system(
  'maim',
  '--hidecursor',
  '--select', # interactive selection
  output,
)

raise "maim failed!" unless result

puts "Created file #{output}"
