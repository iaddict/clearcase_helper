# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "clearcase_helper/version"

Gem::Specification.new do |s|
  s.name        = "clearcase_helper"
  s.version     = ClearcaseHelper::VERSION
  s.authors     = ["Thomas Steinhausen"]
  s.email       = ["ts@image-addicts.de"]
  s.homepage    = ""
  s.summary     = %q{A tool to help on some aspects of clearcase annoyances.}
  s.description = <<-D
    Clearcase has no simple to use command line tool

      - to find and add view only files in a recursive manner
      - to checkout and checkin hijacked files.

    This tool is a simple wrapper to cleartool which allows just that.

    Usage:

      $ cch help
  D

  files = if File.directory?('.git')
            `git ls-files`.split($/)
          elsif File.directory?('.hg')
            `hg manifest`.split("\n").collect {|f| f.gsub(/^[0-9]+\s+/, '')}
          end

  s.files         = files
  s.test_files    = []
  s.executables   = s.files.select {|f| f.match /bin\// }.map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "thor"
end
