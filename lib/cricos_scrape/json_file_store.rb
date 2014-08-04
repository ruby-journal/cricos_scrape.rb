class JsonFileStore
  def initialize(file)
    @file = file
  end

  def save(entity, overwrite = false)
    @entity = entity
    file_empty? || overwrite ? save_data_to_new_file : append_data_to_file
  end

  def file_empty?
    !File.exist?(file_path) || File.zero?(file_path)
  end

  def rollback
    unless file_empty?
      data = JSON.parse(File.read(file_path))
      if data.last.to_json == @entity.to_json
        data.pop
        @entity = data
        save_data_to_new_file
      end
    end
  end

  private
  def save_data_to_new_file
    data_string = @entity.is_a?(Array) ? @entity.to_json : "[#{@entity.to_json}]"
    File.open(file_path, "w") { |file| file.write(data_string) }
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