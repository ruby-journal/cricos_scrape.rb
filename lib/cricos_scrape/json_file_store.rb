class JsonFileStore
  def initialize(file)
    @file = file
  end

  def save(entity)
    backup_old_file
    @entity = entity
    file_empty? ? save_data_to_new_file : append_data_to_file
    remove_tmp_file
  end

  def file_empty?
    !File.exist?(file_path) || File.zero?(file_path)
  end

  def rollback
    FileUtils.rm_rf(file_path)
    FileUtils.copy(file_path("tmp_#{@file}"), file_path) unless file_empty?
    FileUtils.rm_rf(file_path("tmp_#{@file}"))
  end

  private
  def backup_old_file
    FileUtils.copy(file_path, file_path("tmp_#{@file}")) unless file_empty?
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