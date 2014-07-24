class BulkImportCourse
  def self.get(id_min, id_max, id_file)
    course_importer = CricosScrape::CourseImporter.new

    courses_file = JsonFileStore.new('courses.json')
    course_ids_file = JsonFileStore.new('course_ids.json')

    id_range = id_file.nil? ? (id_min..id_max) : File.read(id_file).split(",").map { |s| s.to_i }
    
    id_range.each do |courseID|
      course = course_importer.scrape_course(courseID)

      if !course.nil?
        courses_file.save(course)
        course_ids_file.save(courseID)
        puts "Success with CourseID #{courseID}"
      end
    end
  end
end