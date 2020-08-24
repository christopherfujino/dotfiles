#!/usr/bin/env ruby

if ARGV.length < 3
  puts 'Usage: most-commits.sh [filename] [since] [until]'
  exit 1
end

file = ARGV[0]
since = ARGV[1]
until_date = ARGV[2]
# Have values default to 0
tallies = Hash.new(0)

# Get an array of all hashes between [since] and [until_date] that changed
# [file].
hashes = `git log --pretty=format:"%H" --since="#{since}" --until="#{until_date}" -- "#{file}"`.strip
hashes.lines.each do |hash|
  # Get author of [hash].
  author = `git show --no-patch --pretty=%an "#{hash.strip}"`.strip
  tallies[author] += 1
end
# Sort, in ascending order, by commit count.
puts tallies.sort_by {|k, v| v}.map {|k, v| "#{k} - #{v}"}
puts "Total: #{hashes.lines.length}"
