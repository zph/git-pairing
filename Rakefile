require "bundler"
Bundler.setup

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'

task :build do
  system "bundle install"
  system "gem update --system"
  system "gem update bundler"
  system "gem build git-pairing.gemspec"
end

task :clean do
  system "rm git-pairing-*.*.*.gem"
end

spec = eval(File.read('git-pairing.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

task :default => [:clean,:build]
