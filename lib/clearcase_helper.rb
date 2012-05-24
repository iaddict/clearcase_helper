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

    def checkin_checkedout!
      checkedout_files.each do |file|
        file.checkin!
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

    def checkin!(options={})
      comment = options['comment'] || ''
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

def pnice(s)
  d = ('-'*5)
  puts '', d+" #{s} "+d
end

if $0 == __FILE__

view = ClearcaseHelper::View.new('./')

pnice "view only"
puts view.view_only_files

pnice "hijacked"
puts view.hijacked_files

pnice "checkedout"
puts view.checkedout_files

#pnice "all"
#puts view.all_files_with_status

#view.checkin_view_only_files!
end