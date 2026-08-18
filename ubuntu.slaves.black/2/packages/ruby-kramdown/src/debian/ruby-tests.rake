require 'gem2deb/rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.verbose = true
end
