module ClearcaseHelper
  class CCFile
    attr_accessor :file
    attr_accessor :view

    def initialize(file_name, view)
      @file = file_name
      @view = view
    end

    def is_hijacked?
      file.match /\[hijacked\]/
    end

    def is_view_only?
      !file.match /@@/
    end

    def is_checkedout?
      file.match /@@[^\s]+CHECKEDOUT/
    end

    def short_status
      return 'HI' if is_hijacked?
      return 'CO' if is_checkedout?
      return '? ' if is_view_only?
      return '  '
    end

    def file?
      File.file?(file)
    end

    def directory?
      File.directory?(file)
    end

    def parent_dirname
      File.dirname(file)
    end

    # Refreshes state and returns self.
    #
    # @return [CCFile]
    def refresh_status(options={})
      success, stdout = cleartool("ls #{directory? ? '-directory' : ''} #{self.to_s}", options)
      @file = stdout.strip

      self
    end

    def add!(options={})
      parent = view.file_for(parent_dirname, options)
      if parent.is_view_only?
        parent.add!(options)
        parent.refresh_status(options)
      end

      #cleartool("co -c \"\" -ptime -nwarn #{parent_dirname}", options)
      parent.checkout! unless parent.is_checkedout?
      success, stdout = cleartool("mkelem -c \"\" -ptime #{file}", options)

      refresh_status(options)

      success
    end

    # @param Hash[Symbol => String] - :comment => 'some comment'
    def checkin!(options={})
      comment = options[:comment] || ''
      success, stdout = cleartool("ci -c \"#{comment}\" -identical -ptime #{self.to_s}", options)

      refresh_status(options)

      success
    end

    def checkout!(options={})
      success, stdout = cleartool("co -c \"\" -ptime -nwarn -usehijack #{self.to_s}", options)

      refresh_status(options)

      success
    end

    def to_s
      @file_as_string ||= file.gsub(/@@.*$/, '')
    end

    def <=>(other)
      self.to_s <=> other.to_s
    end

    def cleartool(command, options={})
      cmd = "cleartool #{command}"
      stdout  = `#{cmd}` unless options[:noop]
      success = $? == 0

      puts "# #{cmd} (#{$?}, #{success})=>\n#{stdout.split("\n").collect {|l| "  #{l}"}.join("\n")}" if options[:verbose]

      return success, stdout
    end
  end
end
