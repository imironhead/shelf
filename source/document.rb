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

  def save_as_json(_)
  end

  def to_hash
    { name: name, document_type: document_type, state: state,
      description: description, tags: tags }
  end
end
