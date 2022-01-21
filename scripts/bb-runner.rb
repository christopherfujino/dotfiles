#!/usr/bin/env ruby

# oneof 'flutter' or 'engine'
REPO='flutter'
COMMIT='f4abaa0735eba4dfd8f33f73363911d63931fe03'
#FORCE_UPLOAD_FLAG='-p force_upload=true'
FORCE_UPLOAD_FLAG=''
builders = [
  #'Mac beta Host Engine',
  #'Mac beta Unopt',
  #'Mac beta iOS Engine',
  #'Mac beta iOS Engine Profile',
  'Linux stable docs_publish',
]

successes = []
failures = []
builders.each do |builder|
  out = `bb add \
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
