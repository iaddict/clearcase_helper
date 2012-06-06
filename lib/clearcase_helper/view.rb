module ClearcaseHelper
  class View
    include Executables

    attr_reader :view_path
    attr_reader :identity_map

    def initialize(view_path)
      @view_path = view_path
    end

    def files(refresh=false, options={})
      if @files and !refresh
        return @files
      end

      success, stdout = cleartool("ls -recurse #{@view_path.shellescape}", options)
      raw_files = stdout.split(/\n/)
      raw_files.reject! {|f| f.match(/\.hg|\.git|\.svn/)} # filter artefacts of other vcs

      @files = raw_files.map {|f| CCFile.new(f, self)}
      @identity_map = @files.inject({}) {|memo, file| memo[file.to_s] = file; memo}

      @files
    end

    def view_only_files(refresh=false, options={})
      files(refresh, options).select {|f| f.is_view_only?}
    end

    def hijacked_files(refresh=false, options={})
      files(refresh, options).select {|f| f.is_hijacked?}
    end

    def checkedout_files(refresh=false, options={})
      files(refresh, options).select {|f| f.is_checkedout?}
    end

    def missing_files(refresh=false, options={})
      files(refresh, options).select {|f| f.is_missing?}
    end

    def all_files_with_status(refresh=false, options={})
      show_short = !options[:long]

      files(refresh, options).reject {|file| show_short and file.is_checkedin?}.collect do |file|
        "#{file.short_status} #{file}"
      end
    end

    # @param [String, CCFile] file to get from the identity map. If the file is missing a new instance is added to the map and returned.
    # @return [CCFile]
    def file_for(file, options={})
      file = file.to_s.strip

      cc_file = @identity_map[file]

      if cc_file.nil? && !file.empty?
        cc_file = @identity_map[file] = CCFile.new(file, self).refresh_status(options)
      end

      cc_file
    end

    # @param Hash[Symbol => String] - :comment => 'some comment', :debug => boolean, :noop => :boolean
    def checkin_checkedout!(options={})
      checkedout_files(false, options.merge(:nostdout => true, :noop => false)).each do |file|
        file.checkin!(options)
      end
    end

    # @param Hash[Symbol => String] - :debug => boolean, :noop => :boolean
    def checkout_highjacked!(options={})
      hijacked_files(false, options.merge(:nostdout => true, :noop => false)).each do |file|
        file.checkout!(options)
      end
    end

    # @param Hash[Symbol => String] - :debug => boolean, :noop => :boolean
    def checkin_hijacked!(options={})
      hijacked_files(false, options.merge(:nostdout => true, :noop => false)).each do |file|
        file.checkout!(options)
        file.checkin!(options)
      end
    end

    # @param Hash[Symbol => String] - :debug => boolean, :noop => :boolean
    def add_view_only_files!(options={})
      view_only_files(false, options.merge(:nostdout => true, :noop => false)).sort.each do |file|
        file.add!(options)
      end
    end

    # @param Hash[Symbol => String] - :debug => boolean, :noop => :boolean
    def remove_missing_files!(options={})
      missing_files(false, options.merge(:nostdout => true, :noop => false)).sort.each do |file|
        file.remove!(options)
      end
    end
  end
end
