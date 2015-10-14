require 'fileutils'
require 'json'
require 'uri'

# $DIR_SOURCE = 'source'
# $DIR_TARGET = 'data'
# $PATH_SOURCE = "../#{$DIR_SOURCE}/"
# $PATH_TARGET = "../#{$DIR_TARGET}/"
#
# desc 'build'
# task :build_2 do build end
#
# desc 'run a local server in http://localhost:8000/'
# task :s do
#   `ruby -run -e httpd ../ -p 8000`
# end
#
# def build
#   clean
#   copy_categories
#   generate sources
# end
#
# def clean
#   Dir.glob "#{$PATH_TARGET}*.json" do | data |
#     File.delete data
#   end
# end
#
# def copy_categories
#   Dir.glob("#{$PATH_SOURCE}*.json") do | file |
#     new_file = $PATH_TARGET + File.basename(file)
#
#     FileUtils.cp(file, new_file)
#   end
# end
#
# def generate data
#   generate_index data
# end
#
# def generate_index data
#   categories = data.map do | category |
#     {
#       title: category[:title],
#       count: category[:documents].length,
#       url: category[:url]
#     }
#   end
#
#   index = {
#     title: "iRonhead's Reading List",
#     category: 'index',
#     categories: categories
#   }
#
#   path = $PATH_TARGET + "index.json"
#
#   File.open(path, 'w') { |f| f << index.to_json }
# end
#
# def sources
#   Dir.glob("#{$PATH_SOURCE}*.json").map do | file |
#     json = IO.read(file)
#
#     data = JSON.parse(json, symbolize_names: true)
#
#     data[:url] = "../#{$DIR_TARGET}/#{File.basename file}"
#
#     data
#   end
# end
#
# task :test do
#   ENV['qoo'] = 'foo'
#   puts ENV['qoo']
#   puts ENV['zoo']
# end

desc 'run a local server in http://localhost:4000/'
task :s do
  `ruby -run -e httpd ../ -p 4000`
end

desc 'build'
task :build do
  task_build
end

def load_env
  ENV['source_dir_name'] ||= 'source'
  ENV['target_dir_name'] ||= 'data'
  ENV['source_path'] ||= File.join '..', ENV['source_dir_name']
  ENV['target_path'] ||= File.join '..', ENV['target_dir_name']
end

def task_build
  load_env
  clear_data_folder
  pages = load_pages

  generate_pages pages
  generate_index_page pages
end

def clear_data_folder
  target_path = File.join ENV['target_path'], '*.json'

  Dir.glob(target_path) { |data| File.delete data }
end

# load all json files inside source dir
def load_pages
  page_path = File.join ENV['source_path'], '*.json'

  Dir.glob(page_path).map do |file|
    JSON
      .parse(IO.read(file), symbolize_names: true)
      .merge!(url: File.join(ENV['target_path'], File.basename(file)))
  end
end

# if there is only images in a page, add a carousel in that page.
def add_image_carousel(pages)
  pages.map do |page|
    next unless page[:documents].all? { |doc| doc[:page_type] == 'image' }
    # insert carousel
  end
end

def generate_index_page(pages)
  index = {
    title: "iRonhead's Reading List",
    document_type: 'index'
  }

  index[:documents] = pages.map do |page|
    { document_type: 'list', title: page[:title],
      count: page[:documents].length, url: page[:url] }
  end

  target_path = File.join ENV['target_path'], 'index.json'

  File.open(target_path, 'w') { |f| f << JSON.pretty_generate(index) }
end

def generate_pages(pages)
  pages.each do |page|
    target_path = File.join ENV['target_path'], File.basename(page[:url])

    File.open(target_path, 'w') { |f| f << JSON.pretty_generate(page) }
  end
end
