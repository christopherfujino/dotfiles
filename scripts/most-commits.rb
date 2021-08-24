#!/usr/bin/env ruby

if ARGV.length < 2
  puts 'Usage: most-commits.sh $since $until [$filename]'
  exit 1
end

since = ARGV[0]
until_date = ARGV[1]
file = ARGV[2]

# Have values default to 0
tallies = Hash.new(0)

hashes = if file.nil?
           `git log --pretty=format:"%H" --since="#{since}" --until="#{until_date}"`
         else
           # Get an array of all hashes between [since] and [until_date] that
           # changed [file].
           `git log --pretty=format:"%H" --since="#{since}" --until="#{until_date}" -- "#{file}"`
         end.lines
hashes.each do |hash|
  # Get author of [hash].
  author = `git show --no-patch --pretty=%an "#{hash.strip}"`.strip
  tallies[author] += 1
  #if author =~ /Fujino/
  #  puts `git show --no-patch --format=oneline #{hash}`
  #end
end
# Sort, in ascending order, by commit count.
puts tallies.sort_by {|k, v| v}.map {|k, v| "#{k} - #{v}"}
puts "Total: #{hashes.length}"
