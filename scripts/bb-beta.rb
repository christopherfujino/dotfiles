#!/usr/bin/env ruby

commit='2bafdc822636426fa09afb43236400a60ea432b2'

[
  'Linux beta build_tests',
  'Linux beta framework_tests',
  'Linux beta tool_tests',
  'Linux beta web_tests',
  'Linux beta analyze',
  'Linux beta customer_testing',
  'Linux beta docs',
  'Linux beta fuchsia_precache',
  'Linux beta web_smoke_test',
  'Windows beta build_tests',
  'Windows beta framework_tests',
  'Windows beta tool_tests',
  'Windows beta customer_testing',
  'Mac beta build_tests',
  'Mac beta framework_tests',
  'Mac beta tool_tests',
  'Mac beta customer_testing',
].each do |builder|
  system("bb add -commit 'https://chromium.googlesource.com/external/github.com/flutter/flutter/+/#{commit}' 'flutter/prod/#{builder}'")
end
