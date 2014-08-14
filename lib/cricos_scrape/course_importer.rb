module CricosScrape
  class CourseImporter

    COURSE_URL = 'http://cricos.deewr.gov.au/Course/CourseDetails.aspx'

    attr_reader :agent
    private :agent

    def initialize
      @agent = Mechanize.new(user_agent_alias: 'Windows IE 9')
    end

    def scrape_course(course_id)
      @page = agent.get(url_for(course_id))

      return if course_not_found?

      course = CricosScrape::Course.new
      course.course_id  = course_id
      course.course_name = find_course_name
      course.course_code = find_course_code
      course.dual_qualification = find_dual_qualification
      course.field_of_education = find_field_of_education
      course.broad_field = find_education_broad_field
      course.narrow_field = find_education_narrow_field
      course.detailed_field = find_education_detailed_field
      course.course_level = find_course_level
      course.foundation_studies = find_foundation_studies
      course.work_component = find_work_component
      course.course_language = find_course_language
      course.duration = find_duration
      course.total_cost = find_total_cost

      course.contact_officers = find_contact_officers
      course.location_ids = find_course_location

      course
    end

    private

    def url_for(course_id)
      "#{COURSE_URL}?CourseID=#{course_id}"
    end

    # there is no record not found page
    # instead a search page is returned
    def course_not_found?
      @page.at('#contentBody h1').text == "Course Search"
    end

    def find_value_of_field(field)
      field.text.strip unless field.nil? 
    end

    def find_course_name
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblCourseName')
      find_value_of_field(field)
    end

    def find_course_code
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblCourseCode')
      find_value_of_field(field)
    end

    def find_dual_qualification
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblDualQualification')
      find_value_of_field(field)
    end

    def find_field_of_education
      row = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_trFofEHeader').children
      # NOTE: A space lookalike character might be returned. This is to ensure its conversion to a correct space
      find_value_of_field(row[3]).ord == 160 ? '' : find_value_of_field(row[3])
    end

    def find_education_broad_field
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblFieldOfEducationBroad1')
      find_value_of_field(field)
    end

    def find_education_narrow_field
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblFieldOfEducationNarrow1')
      find_value_of_field(field)
    end

    def find_education_detailed_field
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblFieldOfEducationDetailed1')
      find_value_of_field(field)
    end

    def find_course_level
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblCourseLevel')
      find_value_of_field(field)
    end

    def find_foundation_studies
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblFoundationStudies')
      find_value_of_field(field)
    end

    def find_work_component
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblWorkComponent')
      find_value_of_field(field)
    end

    def find_course_language
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblCourseLanguage')
      find_value_of_field(field)
    end

    def find_duration
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblDuration')
      find_value_of_field(field)
    end

    def find_total_cost
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseDetail_lblTotalCourseCost')
      find_value_of_field(field)
    end

    def find_contact_officers
      contact_officers = []

      contact_officers_list = @page.search('//div[starts-with(@id, "ctl00_cphDefaultPage_tabContainer_sheetContactDetail_contactDetail_pnl")]')

      contact_officers_list.each do |contact_officer|
        @contact_officer_area = contact_officer
        @contact_officer_table = @contact_officer_area.at('table').children
        
        if contains_contact_details_grid?
          contact_officers += find_contact_officer_grid
        else
          contact_officers << find_contact_officer
        end
      end

      contact_officers
    end

    def find_contact_officer_grid
      contact_officers = []

      excess_row_at_the_end_table = 2
      data_row_start = 3
      data_row_end = @contact_officer_table.count - excess_row_at_the_end_table

      for i in data_row_start..data_row_end
        contact_row = @contact_officer_table[i].children

        contact = ContactOfficer.new
        contact.role      = find_contact_officer_role
        contact.name      = find_value_of_field(contact_row[1])
        contact.phone     = find_value_of_field(contact_row[2])
        contact.fax       = find_value_of_field(contact_row[3])
        contact.email     = find_value_of_field(contact_row[4])

        contact_officers << contact
      end

      contact_officers
    end

    def find_contact_officer
      contact           = ContactOfficer.new
      contact.role      = find_contact_officer_role
      contact.name      = find_contact_officer_name
      contact.title     = find_contact_officer_title
      contact.phone     = find_contact_officer_phone
      contact.fax       = find_contact_officer_fax
      contact.email     = find_contact_officer_email

      contact
    end

    def find_contact_officer_role
      row = @contact_officer_area.children
      find_value_of_field(row[1]).sub(':', '')
    end

    def find_contact_officer_name
      row = @contact_officer_table[1].children
      find_value_of_field(row[3])
    end

    def find_contact_officer_title
      row = @contact_officer_table[3].children
      find_value_of_field(row[3])
    end

    def find_contact_officer_phone
      row = @contact_officer_table[5].children
      find_value_of_field(row[3])
    end

    def find_contact_officer_fax
      row = @contact_officer_table[7].children
      find_value_of_field(row[3])
    end

    def find_contact_officer_email
      row = @contact_officer_table[9]
      find_value_of_field(row.children[3]) unless row.nil?
    end

    def contains_contact_details_grid?
      contact_officer_area_css_id = @contact_officer_area.attributes['id'].text
      @page.search("//*[@id='#{contact_officer_area_css_id}']/div/table[starts-with(@id, 'ctl00_cphDefaultPage_tabContainer_sheetContactDetail_contactDetails_grid')]").any?
    end

    #Get all locations of course
    def find_course_location
      location_ids = []

      if location_results_paginated?
        for page_number in 1..total_pages
          jump_to_page(page_number)
          location_ids += fetch_location_ids_from_current_page
        end
      else
        location_ids += fetch_location_ids_from_current_page
      end
      
      location_ids
    end

    def pagination
      @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseLocationList_gridSearchResults .gridPager')
    end

    def location_results_paginated?
      !!pagination
    end

    def total_pages
      pagination.children[1].text.strip[/^Page [0-9]+ of ([0-9]+).*/, 1].to_i
    end

    def current_pagination_page
      pagination.children[1].text.strip[/^Page ([0-9]+) of [0-9]+.*/, 1].to_i
    end

    def jump_to_page(page_number)
      return @page if page_number == current_pagination_page

      hidden_form = @page.form_with :id => "aspnetForm"
      hidden_form['__EVENTTARGET'] = 'ctl00$cphDefaultPage$tabContainer$sheetCourseDetail$courseLocationList$gridSearchResults'
      hidden_form['__EVENTARGUMENT'] = "Page$#{page_number}"
      @page = hidden_form.submit(nil, {'action' => 'change-page'})
    end

    def get_location_id(row_index)
      hidden_form = @page.form_with :id => "aspnetForm"
      hidden_form['__EVENTTARGET'] = 'ctl00$cphDefaultPage$tabContainer$sheetCourseDetail$courseLocationList$gridSearchResults'
      hidden_form['__EVENTARGUMENT'] = "click-#{row_index-3}"
      course_page = hidden_form.submit(nil, {'action' => 'get-location-id'})

      course_page.uri.to_s[/LocationID=([0-9]+)/, 1]
    end

    def fetch_location_ids_from_current_page
      location_ids = []

      # location_list is table contains locations in current page
      location_list = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetCourseDetail_courseLocationList_gridSearchResults').children

      excess_row_at_the_end_table = location_results_paginated? ? 3 : 2
      start_location_row = 3
      end_location_row = location_list.count - excess_row_at_the_end_table

      for i in start_location_row..end_location_row
        location_ids << get_location_id(i)
      end

      location_ids
    end

  end
end
