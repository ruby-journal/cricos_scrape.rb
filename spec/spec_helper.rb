require_relative '../lib/cricos_scrape'
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

def not_found_course_details_uri
  file = File.expand_path("../fixtures/not_found_course_details_uri.html", __FILE__)
  "file://#{file}"
end

def course_details_without_pagination_uri
  file = File.expand_path("../fixtures/course_details_without_pagination_uri.html", __FILE__)
  "file://#{file}"
end