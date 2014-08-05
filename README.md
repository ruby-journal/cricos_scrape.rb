# CRICOS Scraper

![CRICOS Logo](http://cricos.deewr.gov.au/images/cricos.gif)

CRICOS lacks API for data retrieval (so are many government-based services). This gem
helps scrape data from [cricos.deewr.gov.au](http://cricos.deewr.gov.au/).

# Features

Support scrapping following entities:

* Institution
* Course
* Contact

# Usage
  
  There are some rakes in different classes, and they help better importing data. You can follow the directions below:

* Institution
  Get Institution with default agrument (MIN_ID=1, MAX_ID=10000)
  <code>bundle exec rake import:institutions</code>

  Get Institution with specify agrument
  <code>bundle exec rake import:institutions MIN_ID=1 MAX_ID=10000</code>

  Get Institution with file id list
  <code>bundle exec rake import:institutions FILE_INPUT=<path></code>

  Store data to specify file
  <code>bundle exec rake import:institutions OUTPUT_DATA_FILE=<file_name> OUTPUT_ID_FILE=<file_name></code>

* Course
  Similar Institution
  <code>bundle exec rake import:courses</code>

* Contact
  To get all contacts
  <code>bundle exec rake import:contacts</code>

  To get all contacts and overwrite old data
  <code>bundle exec rake import:contacts OVERWRITE=true</code>

  Store data to specify file
  <code>bundle exec rake import:contacts OUTPUT_FILE=<file_name></code>

TO BE DOCUMENTED

# License

GPLv2 for non-commercial.

For commercial app, please contact me in person for licensing quote.
