require 'thor'

module ClearcaseHelper
  class CLI < Thor
    desc "all_files [PATH]", "Shows all files in this view prefixed with its short status (CO: checkedout, HI: hijacked, ~: loaded but missing, ?: only in view)."
    def all_files(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.all_files_with_status
    end
    map ['status', 'st'] => :all_files

    desc "view_only_files [PATH]", "Shows all files that are not added to this view (unversioned files)."
    def view_only_files(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.view_only_files
    end
    map 'vof' => :view_only_files

    desc "hijacked_files [PATH]", "Shows all files that are hijacked."
    def hijacked_files(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.hijacked_files
    end
    map 'hif' => :hijacked_files

    desc "checkedout_files [PATH]", "Shows all files that are checked out."
    def checkedout_files(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.checkedout_files
    end
    map 'cof' => :checkedout_files

    desc "missing_files [PATH]", "Shows all files that are loaded but missing in view."
    def missing_files(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.missing_files
    end
    map 'mf' => :missing_files

    desc "checkout_highjacked [PATH]", "Checks out all highjacked files."
    method_options :verbose => false, :noop => false
    def checkout_highjacked(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.checkout_highjacked!(options)
    end
    map 'cohi' => :checkout_highjacked

    desc "checkin [PATH]", "Checks in all checked out files."
    method_option :comment, :default => '', :aliases => ['-c', '-m'], :desc => 'use <comment> as commit message'
    method_options :verbose => false, :noop => false
    def checkin_checkedout(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.checkin_checkedout!(options)
    end
    map ['ci', 'checkin'] => :checkin_checkedout

    desc "checkin_hijacked [PATH]", "Checks hijacked files out and in again."
    method_options :verbose => false, :noop => false
    def checkin_hijacked(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.checkin_hijacked!(options)
    end
    map 'cihi' => :checkin_hijacked

    desc "add_view_only_files [PATH]", "Adds and checks in files that are not yet versioned."
    method_options :verbose => false, :noop => false
    def add_view_only_files(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.add_view_only_files!(options)
    end
    map ['avo', 'add'] => :add_view_only_files

    desc "remove_missing_files [PATH]", "Removes files (rmname) that are loaded but deleted from view."
    method_options :verbose => false, :noop => false
    def remove_missing_files(path='./')
      view = ClearcaseHelper::View.new(path)
      puts view.remove_missing_files!(options)
    end

    desc "heaven", "Show real help."
    def heaven
      $stderr.puts 'NO HEAVEN HERE - use a proper VCS!'
    end

    desc "version", "Show the version"
    def version
      puts VERSION
    end
  end
end