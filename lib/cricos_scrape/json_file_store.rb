class JsonFileStore
  def initialize(file)
    @file = file
  end

  def save(entity)
    @entity = entity
    
    if data_file_empty?
      save_data_to_new_file
    else
      append_data_to_file
    end
  end

  def data_file_empty?
    !File.exist?(file_path) || File.zero?(file_path)
  end

  private
  def save_data_to_new_file
    data_string = @entity.is_a?(Array) ? @entity.to_json : "[#{@entity.to_json}]"
    File.open(file_path, "a") { |file| file.write(data_string) }
  end

  def append_data_to_file
    File.open(file_path, "r+b") do |file|
      # Move position to before last character "]" in file.
      file.seek(-1, IO::SEEK_END)
      # New data 'll overwrite last character "]". We need add "]" at the end.
      file.write(',' + @entity.to_json + ']')
    end
  end

  def file_path
    File.expand_path("../../../data/#{@file}", __FILE__)
  end
end