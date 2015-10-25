require_relative './document'

# YoutubeDocument
class YoutubeDocument < Document
  attr_reader :youtube_id

  def initialize(doc, document_name)
    super doc, document_name

    @youtube_id = doc['youtube_id']
  end

  def save_as_json(shelf_path)
    path = File.join shelf_path, "#{document_name}.json"

    File.open(path, 'w') { |f| f << JSON.pretty_generate(to_hash) }
  end

  def to_hash
    ydoc = { url: "https://www.youtube.com/embed/#{youtube_id}" }

    super.to_hash.merge ydoc
  end
end
