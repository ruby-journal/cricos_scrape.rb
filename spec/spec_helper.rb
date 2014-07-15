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
