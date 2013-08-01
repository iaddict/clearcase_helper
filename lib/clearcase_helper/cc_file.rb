module ClearcaseHelper
  class CCFile
    include Executables

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

    def is_missing?
      file.match /\[loaded but missing\]/
    end

    def is_checkedin?
      short_status.strip.empty?
    end

    def short_status
      return 'HI' if is_hijacked?
      return 'CO' if is_checkedout?
      return '~ ' if is_missing?
      return '? ' if is_view_only?
      return '  '
    end

    def file?
      File.file?(self.to_s)
    end

    def directory?
      File.directory?(self.to_s)
    end

    def parent_dirname
      File.dirname(self.to_s)
    end

    # Refreshes state and returns self.
    #
    # @return [CCFile]
    def refresh_status(options={})
      success, stdout = cleartool('ls', directory? ? '-directory' : nil, self.to_s, options)
      @file = stdout.strip

      self
    end

    def add!(options={})
      parent = view.file_for(parent_dirname, options)
      if parent.is_view_only?
        parent.add!(options)
        parent.refresh_status(options)
      end

      parent.checkout!(options) unless parent.is_checkedout?
      success, stdout = cleartool('mkelem', '-c', '', '-ptime', file.to_s, options)

      refresh_status(options)

      success
    end

    def remove!(options={})
      parent = view.file_for(parent_dirname, options)

      parent.checkout!(options) unless parent.is_checkedout?
      success, stdout = cleartool('rmname', '-c', '', self.to_s, options)

      
      if success
        # no need to refresh file because this file does not exist anymore,
        # so just remove it from the identity map
        view.forget_file(self)
      else
        # do refresh status since deletion failed
        refresh_status(options)
      end

      success
    end

    # @param Hash[Symbol => String] - :comment => 'some comment'
    def checkin!(options={})
      comment = options[:comment] || ''
      success, stdout = cleartool('ci', '-c', comment, '-identical', '-ptime', self.to_s, options)

      refresh_status(options)

      success
    end

    def checkout!(options={})
      success, stdout = cleartool('co', '-c', '', '-ptime', '-nwarn', is_hijacked? ? '-usehijack' : nil, self.to_s, options)

      refresh_status(options)

      success
    end

    def to_s
      @file_as_string ||= file.gsub(/@@.*$/, '')
    end

    def <=>(other)
      self.to_s <=> other.to_s
    end
  end
end
