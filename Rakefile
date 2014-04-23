require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = Dir.glob('test/rujure/test_*.rb')
end

task :default => [:test]
