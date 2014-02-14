require 'bundler/gem_tasks'
require 'dotenv/tasks'
require 'rake/testtask'

namespace 'test' do |ns|
  test_files             = FileList['spec/**/*_spec.rb']
  integration_test_files = FileList['spec/**/*_integration_spec.rb']
  unit_test_files        = test_files - integration_test_files

  desc "Run unit tests"
  Rake::TestTask.new('unit') do |t|
    t.libs.push 'lib'
    t.libs.push 'spec'
    t.test_files = unit_test_files
    t.verbose = true
  end

  desc "Run integration tests"
  Rake::TestTask.new('integration') do |t|
    t.libs.push 'lib'
    t.libs.push 'spec'
    t.test_files = integration_test_files
    t.verbose = true
  end
end

task :default => %w[dotenv test:unit test:integration]
