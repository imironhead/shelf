require_relative './document'

# YoutubeDocument
class LinkDocument < Document
  attr_reader :url

  def initialize(doc, document_name)
    super doc, document_name

    @url = doc['url']
  end

  def save_as_json(shelf_path)
    path = File.join shelf_path, "#{document_name}.json"

    File.open(path, 'w') { |f| f << JSON.pretty_generate(to_hash) }
  end

  def to_hash
    ydoc = { url: "#{url}" }

    super.to_hash.merge ydoc
  end
end
