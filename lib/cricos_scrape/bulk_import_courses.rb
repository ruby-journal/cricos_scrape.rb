module CricosScrape
  class BulkImportCourses
    attr_reader :output, :min_id, :max_id, :input

    def initialize(output, min_id, max_id, input=nil)
      @range = input ? convert_ids_from_file_to_array(input) : (min_id..max_id).to_a
      return 'Invalid Range ID' if @range.empty?

      @importer = CricosScrape::CourseImporter.new
      @courses_file = CricosScrape::JsonFileStore.new(output['data'])
      @course_ids_file = CricosScrape::JsonFileStore.new(output['ids'])
    end

    def perform
      @range.each do |courseID|
        scrape_course_and_save_to_file(courseID)
      end
    end

    private
    def scrape_course_and_save_to_file(courseID)
      course = @importer.scrape_course(courseID)
      if course
        save_course_data_to_file(courseID, course)
      else
        puts "The Course ID #{courseID} entered is invalid - please try another."
      end
    end

    def save_course_data_to_file(courseID, course)
      @course_ids_file.save(courseID)
      @courses_file.save(course)
      puts "Success with CourseID #{courseID}"
    rescue => e
      @courses_file.rollback
      @course_ids_file.rollback
      puts "Error writing to files with CourseID #{courseID}"
    end

    def convert_ids_from_file_to_array(input)
      File.read(input).split(",").map { |s| s.to_i } rescue []
    end
  end
end