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
  
  There are some rake tasks that help import data. You can follow the directions below:

* Import Institutions

  Following rake task will loop through the pages with provided IDs and will store the results in OUTPUT_DATA_FILE. You can find default ENVIRONMENT settings below:

  ## Default ENVIRONMENT

  <code>
  MIN_ID = 1
  MAX_ID = 10000
  OUTPUT_DATA_FILE = institutions.json
  OUTPUT_ID_FILE = institution_ids.json
  </code>

  All files will be saved in folder "data". Only input file name in OUTPUT_DATA_FILE and OUTPUT_ID_FILE

  Alternatively, you can specify a file with a list of IDs instead of looping through ID via FILE_INPUT.

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

* Import Courses 
  Courses have similar syntax with Institutions.
  <code>bundle exec rake import:courses</code>

* Import Contacts

  Following rake task will find all contacts and will store the results into OUTPUT_FILE

  <code>OUTPUT_FILE = contacts.json</code>

  If enter OVERWRITE = true. This rake will overwrite old contacts in OUTPUT_FILE with new contacts
  <code>bundle exec rake import:contacts OVERWRITE=true</code>
  
  To get all contacts
  <code>bundle exec rake import:contacts</code>

  Store data to specify file
  <code>bundle exec rake import:contacts OUTPUT_FILE=<file_name></code>

TO BE DOCUMENTED

# License

GPLv2 for non-commercial.

For commercial app, please contact me in person for licensing quote.
