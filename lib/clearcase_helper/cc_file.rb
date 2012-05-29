module ClearcaseHelper
  class CCFile
    attr_accessor :file

    def initialize(file)
      @file = file
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

    def add!
      `cleartool co -c "" -ptime -nwarn #{parent_dirname}`
      `cleartool mkelem -c "" -ptime #{file}`
      $? == 0
    end

    # @param Hash[Symbol => String] - :comment => 'some comment'
    def checkin!(options={})
      comment = options[:comment] || ''
      puts cmd = "cleartool ci -c \"#{comment}\" -identical -ptime #{self.to_s}"
      `#{cmd}`
      $? == 0
    end

    def checkout!
      `cleartool co -c "" -ptime -nwarn -usehijack #{self.to_s}`
      $? == 0
    end

    def to_s
      @file_as_string ||= file.gsub(/@@.*$/, '')
    end

    def <=>(other)
      self.to_s <=> other.to_s
    end
  end
end
