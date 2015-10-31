# env.rb
# Env
class Env
  attr_reader :root_url
  attr_reader :root_path
  attr_reader :source_name
  attr_reader :target_name
  attr_reader :shelves_name

  def self.mkdir_unless_exist(path)
    FileUtils.mkdir_p path unless File.directory?(path)
  end

  def initialize
    @root_url = '.'
    @root_path = '..'
    @source_name = 'source'
    @target_name = 'target'
    @shelves_name = 'shelves'
  end

  def source_path
    File.join root_path, source_name
  end

  def source_shelves_path
    File.join source_path, shelves_name
  end

  def target_path
    File.join root_path, target_name
  end

  def target_shelves_path
    File.join target_path, shelves_name
  end

  def target_url
    File.join root_url, target_name
  end

  def target_shelves_url
    File.join target_url, shelves_name
  end

  def update_directories
    FileUtils.rm_r target_path if File.directory?(target_path)

    Env.mkdir_unless_exist target_path
    Env.mkdir_unless_exist target_shelves_path
  end
end
