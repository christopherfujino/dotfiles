module BuildSystem
  # https://docs.ruby-lang.org/en/3.4/ERB.html
  require 'erb'

  # module instance scope
  @re = /^(.*)\.erb$/

  def self._is_outdated(target_path, input_path)
    unless File.exist? input_path
      raise "Expected input file #{input_path} to exist, but it did not"
    end
    input = File.new(input_path, mode='r')
    unless File.exist? target_path
      return nil, input, true
    end
    target = File.new(target_path, mode='r')
    return target, input, (input.mtime > target.mtime)
  end

  def self.build(dep, vars, out)
    ## Create a small inner function so that the local namespace is clean
    _build = lambda do |vars, template|
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

    target_relative_path = @re.match(File.basename dep).captures[0]
    target_path = "#{out}/#{target_relative_path}"
    input = File.new(dep, mode='r')

    puts "Compiling #{dep} -> #{target_path}..."
    target = File.open(target_path, 'w', 0644)

    template = ERB.new(input.read)

    compiled_template = _build.call(vars, template)

    target.write(compiled_template)
    target.close()
  end
end
