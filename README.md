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

* Import Institution

  Following rake task will loop through the pages with provided IDs and will stored the results into somefile defined with default ENVIRONMENT

  ## Default ENVIRONMENT

  <code>
  MIN_ID = 1
  MAX_ID = 10000
  OUTPUT_DATA_FILE = institutions.json
  OUTPUT_ID_FILE = institution_ids.json
  </code>

  If you enter FILE_INPUT. Rake task will ignore MIN_ID and MAX_ID. Import ID will be taken from FILE_INPUT content.

  Content FILE_INPUT should have the following form
  <code>ID1,ID2,ID3</code>

  ## Syntax

  Get Institution with default agrument (MIN_ID=1, MAX_ID=10000)
  <code>bundle exec rake import:institutions</code>

  Get Institution with specify agrument
  <code>bundle exec rake import:institutions MIN_ID=1 MAX_ID=10000</code>

  Get Institution with file id list
  <code>bundle exec rake import:institutions FILE_INPUT=<path></code>

  Store data to specify file
  <code>bundle exec rake import:institutions OUTPUT_DATA_FILE=<file_name> OUTPUT_ID_FILE=<file_name></code>

  Combining ENVIRONMENT
  <code>bundle exec rake import:institutions MIN_ID=1 MAX_ID=10000 OUTPUT_DATA_FILE=<file_name> OUTPUT_ID_FILE=<file_name></code>

* Course
  Similar Institution but with different keyword
  <code>bundle exec rake import:courses</code>

* Contact

  Following rake task will find all contacts and will stored the results into somefile defined by ENVIRONMENT OUTPUT_FILE

  <code>OUTPUT_FILE = contacts.json</code>

  If enter OVERWRITE = true. This rake will overwrite old contacts in OUTPUT_FILE with new contacts

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
