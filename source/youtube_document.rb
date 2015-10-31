require_relative './document'

# YoutubeDocument
class YoutubeDocument < Document
  attr_reader :youtube_id

  def initialize(doc, document_name)
    super doc, document_name

    @youtube_id = doc['youtube_id']
  end

  def save_as_json(shelf_path, shelf_url)
    doc_path = File.join shelf_path, "#{document_name}.json"

    File.open(doc_path, 'w') do |f|
      f << JSON.pretty_generate(to_detail_hash(shelf_url))
    end
  end

  def to_detail_hash(shelf_url)
    ydoc = { url: "https://www.youtube.com/embed/#{youtube_id}" }

    super(shelf_url).merge ydoc
  end
end
