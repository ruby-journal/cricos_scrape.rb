require_relative '../lib/cricos_scrape'
require_relative '../lib/bulk_import_institutions'
require 'rspec/its'

def institution_details_with_po_box_postal_address_uri
  file = File.expand_path("../fixtures/institution_details_with_po_box_postal_address.html", __FILE__)
  "file://#{file}"
end

def institution_details_with_trading_name_uri
  file = File.expand_path("../fixtures/institution_details_with_trading_name.html", __FILE__)
  "file://#{file}"
end

def not_found_institution_details_uri
  file = File.expand_path("../fixtures/not_found_institution_details.html", __FILE__)
  "file://#{file}"
end

def institution_details_without_pagination_location_uri
  file = File.expand_path("../fixtures/institution_details_without_pagination_location_uri.html", __FILE__)
  "file://#{file}"
end

def institution_details_with_pagination_location_page_1_uri
  file = File.expand_path("../fixtures/institution_details_with_pagination_location_page_1_uri.html", __FILE__)
  "file://#{file}"
end

def institution_details_with_pagination_location_page_2_uri
  file = File.expand_path("../fixtures/institution_details_with_pagination_location_page_2_uri.html", __FILE__)
  "file://#{file}"
end

def courses_list_by_location_id_uri
  file = File.expand_path("../fixtures/courses_list_by_location_id_uri.html", __FILE__)
  "file://#{file}"
end

def contact_details_of_state_act_uri
  file = File.expand_path("../fixtures/contact_details_of_state_act_uri.html", __FILE__)
  "file://#{file}"
end

def contact_details_of_state_wa_uri
  file = File.expand_path("../fixtures/contact_details_of_state_wa_uri.html", __FILE__)
  "file://#{file}"
end

def not_found_course_details_uri
  file = File.expand_path("../fixtures/not_found_course_details_uri.html", __FILE__)
  "file://#{file}"
end

def course_details_without_pagination_uri
  file = File.expand_path("../fixtures/course_details_without_pagination_uri.html", __FILE__)
  "file://#{file}"
end

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

def data_file_path(file_name)
  File.expand_path("../../data/#{file_name}", __FILE__)
end