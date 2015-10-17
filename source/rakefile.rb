require 'fileutils'
require 'json'
require 'uri'

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

  process_youtube pages
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

def process_youtube(pages)
  pages.each do |page|
    page[:documents].each do |document|
      next if document[:document_type] != 'youtube'
      document[:embed_url] = document[:url].gsub('watch?v=', 'embed/')
    end
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
