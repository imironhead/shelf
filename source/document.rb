# document.rb
# Document
class Document
  attr_reader :name
  attr_reader :document_type
  attr_reader :state
  attr_reader :tags
  attr_reader :description
  attr_reader :document_name

  def initialize(doc, document_name)
    @name = doc['name'] || ''
    @document_type = doc['document_type'] || 'post'
    @state = doc['state'] || 'finished'
    @description = doc['description'] || ''
    @tags = (doc['tags'] || []).map(&:to_sym)
    @document_name = document_name
  end

  def save_as_json(_, _)
  end

  def to_detail_hash(shelf_url)
    parent_url = File.join shelf_url, 'shelf_0.json'

    { name: name, document_type: document_type, state: state,
      description: description, tags: tags, parent_url: parent_url }
  end

  def to_brief_hash(shelf_url)
    { name: name, document_type: document_type,
      url: File.join(shelf_url, "#{document_name}.json") }
  end
end
