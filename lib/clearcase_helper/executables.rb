module ClearcaseHelper
  module Executables
    # @param [String] command for cleartool to execute. including all cleartool options.
    # @param [Hash] options :noop => boolean, :vebose => boolean, :nostdout => boolean
    # @return [Array[Boolean, String]] success, stdout
    def cleartool(*args)
      the_args = args.dup.compact
      the_args.unshift('cleartool')

      options = if the_args.last.kind_of? Hash
        the_args.pop
      else
        {}
      end

      puts "# $ #{the_args.join(' ')}" if options[:verbose]

      success, stdout  = options[:noop] ? '' : sh_exec(*the_args)

      puts "# => (#{$?}, #{success ? 'success' : 'failure'})=>" if options[:verbose]

      if options[:verbose] && !options[:nostdout] && !stdout.empty?
        puts stdout.split("\n").collect {|l| "#  #{l}"}.join("\n")
      end

      $stdout.flush

      return success, stdout
    end

    # Executes given command. Arguments are the same as Kernel#system.
    # @return [Array[Boolean, String]] success, stdout and stderr merged
    def sh_exec(*args)
      unless args.last.kind_of? Hash
        args << {}
      end

      opts = args.last
      opts[:err] = [:child, :out] # write stdout and stderr to pipe, so we can read it later

      out = IO.popen(args, 'r') {|io| io.read}
      success = $? == 0

      return success, out
    end
  end
end