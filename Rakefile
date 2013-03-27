# encoding: utf-8

require 'bundler'
begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = 'cleverbot'
  gem.homepage = 'https://github.com/benmanns/cleverbot'
  gem.license = 'MIT'
  gem.summary = 'Ruby wrapper for Cleverbot.'
  gem.description = 'Ruby wrapper for Cleverbot.'
  gem.email = 'benmanns@gmail.com'
  gem.authors = 'Benjamin Manns'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :spec do |spec|
  spec.pattern = FileList[File.join('spec', '**', '*_spec.rb')]
end

task :default => :spec

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cleverbot #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include(File.join('lib', '**', '*.rb'))
end
