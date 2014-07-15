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
