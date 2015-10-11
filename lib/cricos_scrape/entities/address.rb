module CricosScrape
  class Address < Struct.new(:address_line_1, :address_line_2, :suburb, :state, :postcode)
  end
end