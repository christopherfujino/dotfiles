#!/usr/bin/env ruby

procs = Dir.entries('/proc').select {|file| /^\d+$/.match(file)}
procs.each do |pid|
  cmdline = File.read("/proc/#{pid}/cmdline").split("\x00")
  if cmdline.length >= 2 && cmdline[0].end_with?('dart') && cmdline[1] == 'test'
    puts("About to kill #{cmdline} PID: #{pid}")
    Process.kill('KILL', pid.to_i)
  end
end
