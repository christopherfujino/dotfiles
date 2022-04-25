#!/usr/bin/env ruby

# oneof 'flutter' or 'engine'
REPO='engine'
COMMIT='b3af521a050e6ef076778bcaf16e27b2521df8f8'
FORCE_UPLOAD_FLAG='-p force_upload=true'
XCODE='12a7209'
builders = [
  'Mac stable iOS Engine Profile',
  'Mac stable iOS Engine Release',
]

#bb add -p force_upload=true -commit "https://chromium.googlesource.com/external/github.com/flutter/engine/+/9c6837c2b68d7a0413511ad87fc34f1f45b84cd7" "flutter/prod/Linux Host Engine"

successes = []
failures = []
builders.each do |builder|
  out = `bb add \
    -p '$flutter/osx_sdk={"sdk_version": "#{XCODE}"}' \
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
