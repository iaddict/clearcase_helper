module ClearcaseHelper
  class View
    attr_reader :view_path

    def initialize(view_path)
      @view_path = view_path
    end

    def files(refresh=false)
      if @files and !refresh
        return @files
      end

      raw_files = `cleartool ls -recurse #{@view_path}`.split(/\n/)
      raw_files.reject! {|f| f.match(/\.hg/)}

      @files = raw_files.map {|f| CCFile.new(f)}
    end

    def view_only_files(refresh=false)
      files(refresh).select {|f| f.is_view_only?}
    end

    def hijacked_files(refresh=false)
      files(refresh).select {|f| f.is_hijacked?}
    end

    def checkedout_files(refresh=false)
      files(refresh).select {|f| f.is_checkedout?}
    end

    def all_files_with_status(refresh=false)
      files(refresh).collect do |file|
        "#{file.short_status} #{file}"
      end
    end

    # @param Hash[Symbol => String] - :comment => 'some comment'
    def checkin_checkedout!(options={})
      checkedout_files.each do |file|
        file.checkin!(options)
      end
    end

    def checkout_highjacked!
      hijacked_files.each do |file|
        file.checkout!
      end
    end

    def checkin_hijacked!
      hijacked_files.each do |file|
        file.checkout!
        file.checkin!
      end
    end

    def add_view_only_files!
      view_only_files.sort.each do |file|
        file.add!
      end
    end
  end
end
