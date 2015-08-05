# encoding: utf-8

require 'rspec/core/rake_task'
require 'bundler/version'
require 'bundler/gem_tasks'
require 'rdoc/task'

desc "Build the Gem"
task :build do  
  sh 'gem build qddrud.gemspec'
end

desc "Release the Gem"
task :release => :build do  
  sh "gem push bundler-#{Bunder::VERSION}"
end  

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('lib/*.rb', 'lib/drud/*.rb')
end

desc 'Run rspec tests'
RSpec::Core::RakeTask.new(:spec)
