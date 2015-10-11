require_relative './importer/course_importer'
require_relative './agent'

module CricosScrape
  class BulkImportCourses
    def initialize(min_id=0, max_id=10000)
      @range = (min_id..max_id).to_a
      @agent = CricosScrape.agent
    end

    def perform
      @range.each do |course_id|
        scrape(course_id)
      end
    end

    private

    attr_reader :min_id, :max_id, :input, :agent

    def scrape(course_id)
      course = CourseImporter.new(agent, course_id: course_id).run

      if course
        puts course.to_json
      else
        STDERR.puts "Could not find course with Course ID #{course_id}"
      end
    end
  end
end