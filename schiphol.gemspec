# -*- encoding: utf-8 -*-
require File.expand_path('../lib/schiphol/version', __FILE__)

Gem::Specification.new do |s|
  
  s.name        = 'schiphol'
  s.version     = Schiphol::VERSION
  s.authors     = ['Louis Mullie']
  s.email       = ['louis.mullie@gmail.com']
  s.homepage    = 'https://github.com/louismullie/schiphol'
  s.summary     = %q{ Schiphol: a smart file downloader for Ruby. }
  s.description = %q{ Schiphol is a Ruby downloader script with progress bar, retries, MIME type detection and ZIP file extraction. }
  
  # Add all files.
  s.files = Dir['lib/**/*'] + ['README.md', 'LICENSE']
  
  # Runtime dependencies
  s.add_runtime_dependency 'rubyzip', '>= 0.9.6.1'
  s.add_runtime_dependency 'progressbar', '>= 0.10.0'
  
end