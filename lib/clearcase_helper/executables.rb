module ClearcaseHelper
  module Executables
    # @param [String] command for dleartool to execute. including all cleartool options.
    # @param [Hash] options :noop => boolean, :vebose => boolean, :nostdout => boolean
    # @return [Array[Boolean, String]] success, stdout
    def cleartool(command, options={})
      cmd = "cleartool #{command}"

      stdout  = options[:noop] ? '' : `#{cmd}`
      success = $? == 0

      puts "# #{cmd} (#{$?}, #{success})=>" if options[:verbose]
      if options[:verbose] && !options[:nostdout] && !stdout.empty?
        puts stdout.split("\n").collect {|l| "  #{l}"}.join("\n")
      end

      $stdout.flush

      return success, stdout
    end
  end
end