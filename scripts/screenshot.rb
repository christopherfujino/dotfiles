#!/usr/bin/env ruby

require 'date'

home = ENV['HOME']
raise 'You do not have a $HOME env var set' if home.nil?

tmp = "#{home}/tmp"
unless Dir.exist? tmp
  puts "Creating temp dir at #{tmp}..."
  Dir.mkdir tmp
end

filename = "#{DateTime.now.strftime('%Y-%m-%d-%H_%M')}-screenshot.png"
output = "#{tmp}/#{filename}"

wayland_display = ENV['WAYLAND_DISPLAY']
if wayland_display.nil?
  result = Kernel.system(
    'maim',
    '--hidecursor',
    '--select', # interactive selection
    output,
  )

  raise "maim failed!" unless result
else
  # default 6
  compression=6
  result = Kernel.system(
    "grim -g \"$(slurp)\" -t png -l #{compression} #{output}",
  )

  raise "maim failed!" unless result
end

puts "Created file #{output}"
