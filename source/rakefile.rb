require 'fileutils'
require 'json'
require 'uri'
require 'yaml'
require_relative './env'
require_relative './shelf'

desc 'run a local server in http://localhost:4000/'
task :s do
  `ruby -run -e httpd ../ -p 4000`
end

desc 'build'
task :build do
  task_build
end

def task_build
  env = Env.new

  env.update_directories

  Shelf.create_shelves env
end
