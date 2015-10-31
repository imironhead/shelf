require_relative './document'

# YoutubeDocument
class ImageDocument < Document
  attr_reader :url
  attr_reader :urls

  def initialize(doc, document_name)
    super doc, document_name

    @url = doc['url']
    @urls = doc['urls']
  end

  def save_as_json(shelf_path, shelf_url)
    doc_path = File.join shelf_path, "#{document_name}.json"

    File.open(doc_path, 'w') do |f|
      f << JSON.pretty_generate(to_detail_hash(shelf_url))
    end
  end

  def to_detail_hash(shelf_url)
    temp = {}

    temp[:url] = url unless url.nil?

    temp[:urls] = urls unless urls.nil?

    super(shelf_url).merge(temp)
  end
end
