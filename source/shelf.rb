require 'yaml'
require_relative './youtube_document'

# Shelf
class Shelf
  attr_reader :name
  attr_reader :description
  attr_reader :documents
  attr_reader :document_name

  def self.create_shelves(env)
    Dir.glob(File.join(env.source_shelfs_path, '*'))
      .select { |folder| File.directory? folder }
      .map { |folder| Shelf.new folder }
      .reject { |shelf| shelf.documents.empty? }
      .each { |s| s.save env }
  end

  def initialize(path)
    load_index path
    load_documents path
  end

  def load_index(path)
    @document_name = File.basename path

    desc_path = File.join path, 'description.yaml'
    desc = File.exist?(desc_path) ? YAML.load_file(desc_path) : {}

    @name = desc['name'] || 'shelf'
    @description = desc['description'] || 'a little shelf'
  end

  def load_documents(path)
    @documents = Dir.glob(File.join path, '*')
                 .reject { |file| File.basename(file) == 'description.yaml' }
                 .map { |file| load_document file }
  end

  def load_document(yaml_path)
    doc = YAML.load_file(yaml_path)
    document_name = File.basename(yaml_path, File.extname(yaml_path))

    case doc['document_type']
    when 'youtube'
      YoutubeDocument.new doc, document_name
    end
  end

  def save(env)
    shelf_path = File.join env.target_shelfs_path, document_name
    shelf_url = File.join env.target_shelfs_url, document_name

    save_index_as_json shelf_path, shelf_url

    documents.each { |doc| doc.save_as_json shelf_path }
  end

  def save_index_as_json(shelf_path, shelf_url)
    FileUtils.mkdir_p shelf_path unless File.directory?(shelf_path)

    # TODO: paginate
    path = File.join shelf_path, 'shelf_0.json'

    docs = documents.map do |doc|
      { name: doc.name, document_type: doc.document_type,
        url: File.join(shelf_url, "#{doc.document_name}.json") }
    end

    shelf = { name: name, document_type: 'shelf',
              description: description, documents: docs }

    File.open(path, 'w') { |f| f << JSON.pretty_generate(shelf) }
  end
end
