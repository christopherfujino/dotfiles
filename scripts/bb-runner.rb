#!/usr/bin/env ruby

# oneof 'flutter' or 'engine'
REPO='engine'
COMMIT='9d517f475ba1282b619477bde8e708d6a34287cf'
FORCE_UPLOAD_FLAG='-p force_upload=true'
builders = [
  'Mac beta Host Engine',
  'Mac beta Unopt',
  'Mac beta iOS Engine',
  'Mac beta iOS Engine Profile',
  'Mac beta iOS Engine Release',
]

successes = []
failures = []
builders.each do |builder|
  out = `bb add \
    -p '$flutter/osx_sdk={"sdk_version": "11e708"}' \
    #{FORCE_UPLOAD_FLAG} \
    -commit \
    "https://chromium.googlesource.com/external/github.com/flutter/#{REPO}/+/#{COMMIT}" \
    "flutter/prod/#{builder}"
    `
  if $?.success?
    successes.push(out)
  else
    failures.push(out)
  end
  print out
end

if failures.length > 0
  puts "\nHad #{failures.length} failures:\n"
  failures.each {|f| puts "\t#{f}\n"}
end

puts "#{successes.length} successes and #{failures.length} failures."
