class JsonFileStore
  def initialize(file)
    @file = file
  end

  def save(entity)
    backup_old_file
    @entity = entity
    
    if empty_data_file?
      save_data_to_new_file
    else
      append_data_to_file
    end

    remove_tmp_file
  end

  def empty_data_file?
    !File.exist?(file_path) || File.zero?(file_path)
  end

  def rollback
    FileUtils.rm_rf(file_path)
    FileUtils.copy(file_path("tmp_#{@file}"), file_path) unless empty_data_file?
    FileUtils.rm_rf(file_path("tmp_#{@file}"))
  end

  private
  def backup_old_file
    FileUtils.copy(file_path, file_path("tmp_#{@file}")) unless empty_data_file?
  end

  def remove_tmp_file
    FileUtils.rm_rf(file_path("tmp_#{@file}"))
  end

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

  def file_path(file = @file)
    File.expand_path("../../../data/#{file}", __FILE__)
  end
end