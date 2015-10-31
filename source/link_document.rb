require_relative './document'

# YoutubeDocument
class LinkDocument < Document
  attr_reader :url

  def initialize(doc, document_name)
    super doc, document_name

    @url = doc['url']
  end

  def save_as_json(shelf_path, shelf_url)
    doc_path = File.join shelf_path, "#{document_name}.json"

    File.open(doc_path, 'w') do |f|
      f << JSON.pretty_generate(to_detail_hash(shelf_url))
    end
  end

  def to_detail_hash(shelf_url)
    super(shelf_url).merge(url: "#{url}")
  end
end
