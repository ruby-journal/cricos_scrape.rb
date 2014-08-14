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
      @range.each do |providerID|
        scrape_course_and_save_to_file(providerID)
      end
    end

    private
    def scrape_course_and_save_to_file(providerID)
      course = @importer.scrape_course(providerID)
      if course
        save_course_data_to_file(providerID, course)
      else
        puts "The Provider ID #{providerID} entered is invalid - please try another."
      end
    end

    def save_course_data_to_file(providerID, course)
      @course_ids_file.save(providerID)
      @courses_file.save(course)
      puts "Success with ProviderID #{providerID}"
    rescue => e
      @courses_file.rollback
      @course_ids_file.rollback
      puts "Error writing to files with ProviderID #{providerID}"
    end

    def convert_ids_from_file_to_array(input)
      File.read(input).split(",").map { |s| s.to_i } rescue []
    end
  end
end