module CricosScrape
  class Course < Struct.new(:course_id, :course_name, :course_code, :dual_qualification, :field_of_education, :broad_field, :narrow_field, :detailed_field, :course_level, :foundation_studies, :work_component, :course_language, :duration, :total_cost, :contact_officers, :location_ids)
  end
end