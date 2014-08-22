module CricosScrape
  class BulkImportCourses
    attr_reader :output, :min_id, :max_id, :input

    def initialize(output, min_id, max_id, input=nil)
      @range = input ? convert_ids_from_file_to_array(input) : (min_id..max_id).to_a
      return 'Invalid Range ID' if @range.empty?

      @importer = CricosScrape::CourseImporter.new
      @courses_file = CricosScrape::JsonFileStore.new(output['data'])
      @last_course_id_file = CricosScrape::JsonFileStore.new(output['id'])
    end

    def perform
      @range.each do |courseID|
        scrape_course_and_save_to_file(courseID)
      end
    end

    private
    def scrape_course_and_save_to_file(courseID)
      course = @importer.scrape_course(courseID)
      @last_course_id_file.save(courseID, true) rescue nil

      if course
        save_course_data_to_file(courseID, course)
      else
        puts "The Course ID #{courseID} entered is invalid - please try another."
      end
    end

    def save_course_data_to_file(courseID, course)
      @courses_file.save(course)
      puts "Success with CourseID #{courseID}"
    rescue => e
      puts "Error writing to files with CourseID #{courseID}"
    end

    def convert_ids_from_file_to_array(input)
      File.read(input).split(",").map { |s| s.to_i } rescue []
    end
  end
end