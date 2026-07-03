# https://docs.ruby-lang.org/en/3.4/ERB.html
require 'erb'

$re = /^(.*)\.erb$/

def _is_outdated(target_path, input_path)
  unless File.exist? input_path
    raise "Expected input file #{input_path} to exist, but it did not"
  end
  unless File.exist? target_path
    return true
  end
  target = File.new(target_path, mode='r')
  input = File.new(input_path, mode='r')
  return target, input, (input.mtime > target.mtime)
end

def build(deps, vars, input_root, out)
  ## Create a small inner function so that the local namespace is clean
  def _build(vars, template)
    b = Kernel.binding
    vars.each_pair do |k, v|
      b.local_variable_set k, v
    end

    # TODO: catch and handle exceptions
    template.result(b)
  end

  unless Dir.exist? out
    puts "creating: #{out}"
    Dir.mkdir(out, 0755)
  end

  deps.each do |dep|
    target_relative_path = $re.match(dep).captures[0]
    target_path = "#{out}/#{target_relative_path}"
    input_path = "#{input_root}/#{dep}"
    target, input, is_outdated = _is_outdated(target_path, input_path)
    unless is_outdated
      strftime = target.mtime.strftime '%b %d %H:%M'
      puts "#{File.basename target_path} is up to date (#{strftime}), skipping build"
      next
    end

    puts "Compiling #{dep}..."
    target = File.open(target_path, 'w', 0644)

    template = ERB.new(IO.read(input_path))

    compiled_template = _build(vars, template)

    target.write(compiled_template)
    target.close()
  end
end
