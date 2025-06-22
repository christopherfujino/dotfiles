#!/usr/bin/env ruby

hex_colors = [
  '2D2D2D',
  'F2777A',
  '99CC99',
  'FFCC66',
  '6699CC',
  'CC99CC',
  '66CCCC',
  'D3D0C8',
  '747369',
  'F2777A',
  '99CC99',
  'FFCC66',
  '6699CC',
  'CC99CC',
  '66CCCC',
  'F2F0EC',
]

hex_colors.each_with_index do |color, i|
  red = (color.slice 0, 2).to_i 16
  green = (color.slice 2, 2).to_i 16
  blue = (color.slice 4, 2).to_i 16
  puts "printf \"\\033[3;#{i};#{red};#{green};#{blue}}\""
end
