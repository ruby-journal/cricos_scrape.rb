class BulkImportCourses
  attr_reader :results_file, :id_min, :id_max, :id_file

  def initialize(results_file, id_min, id_max, id_file)
    @id_min, @id_max, @id_file = [id_min, id_max, id_file]

    @course_importer = CricosScrape::CourseImporter.new
    
    @courses_file = JsonFileStore.new(results_file['data'])
    @course_ids_file = JsonFileStore.new(results_file['ids'])
  end

  def perform
    id_range.each do |courseID|
      scrape_course_and_save_to_file(courseID)

      puts "Success with CourseID #{courseID}" if course_existed?
    end
  end

  private
  def scrape_course_and_save_to_file(courseID)
    @course = @course_importer.scrape_course(courseID)

    if course_existed?
      @courses_file.save(@course)
      @course_ids_file.save(courseID)
    end
  end

  def id_range
    @id_file.nil? ? (@id_min..@id_max) : convert_ids_from_file_to_array
  end

  def convert_ids_from_file_to_array
    File.read(@id_file).split(",").map { |s| s.to_i }
  end

  def course_existed?
    !!@course
  end
end