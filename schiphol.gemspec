$:.push File.expand_path('../lib', __FILE__)

require 'schiphol'

Gem::Specification.new do |s|
  
  s.name        = 'schiphol'
  s.version     = Schiphol::VERSION
  s.authors     = ['Louis Mullie']
  s.email       = ['louis.mullie@gmail.com']
  s.homepage    = 'https://github.com/louismullie/schiphol'
  s.summary     = %q{ Schiphol: a smart file downloader for Ruby. }
  s.description = %q{ Schiphol is a smart file downloader for Ruby, with automatic file type resolution by MIME header, progress bar with ETR, extraction of downloaded ZIP archives, and auto-retries for a preset number of times. }
  
  # Add all files.
  s.files = Dir['lib/**/*'] + ['README.md', 'LICENSE']
  
  s.post_install_message = 
  "********************************************************************************\n\n" +
  "Thank you for installing Schiphol!\n\n" +
  "********************************************************************************\n\n"
  
  # Runtime dependencies
  s.add_runtime_dependency 'rubyzip', '>= 0.9.6.1'
  s.add_runtime_dependency 'progressbar', '>= 0.10.0'
  
end