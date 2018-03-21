#!/usr/bin/env ruby

hsh = Hash.new(0)
ARGF.each { |line| hsh[line] += 1 }
hsh.select! { |_, count| count > 1 }
if hsh.length > 0
  puts "Warning: #{hsh.length} duplicate line#{'s' if hsh.length > 1} found!"
  hsh.each do |line, count|
    puts "The following line found #{count} time{'s' if count > 1}:"
    puts line
  end
  exit 1
else
  exit 0
end
