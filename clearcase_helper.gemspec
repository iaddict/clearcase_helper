# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "./version"

Gem::Specification.new do |s|
  s.name        = "clearcase_helper"
  s.version     = ClearcaseHelper::VERSION
  s.authors     = ["Thomas Steinhausen"]
  s.email       = ["ts@image-addicts.de"]
  s.homepage    = ""
  s.summary     = %q{A tool to help on some aspects of clearcase annoyances.}
  s.description = %q{A tool to help on some aspects of clearcase annoyances.}

  s.files         = `hg manifest`.split("\n").collect {|f| f.gsub(/^[0-9]+\s+/, '')}
  s.test_files    = ''
  s.executables   = s.files.select {|f| f.match /bin\// }.map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "thor"
end
