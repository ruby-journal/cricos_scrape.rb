module CricosScrape
  class ContactOfficer < Struct.new(:role, :name, :title, :phone, :fax, :email)
  end
end