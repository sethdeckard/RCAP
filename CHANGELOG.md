Change Log
==========

## 1.3.1 - 25 February 2012

* Moved XML_PRETTY_PRINTER into RCAP namespace to avoid namespace issues
* Added Resource#decoded_deref_uri
* RCAP::Alert.from_xml can load from a String or IO object

## 1.3.0 - 15 December 2011

* Removed Resource#deref_uri= in 1.1 and 1.2 API. 
* Added Resource#calculate_hash_and_size to calculate size and SHA1 hash of deref_uri if present
* Hash and size of dereferenced URI are also calculated on an explicit call to Resource#dereference_uri!

## 1.2.4 - 4 December 2011

* Fixed parsing bug when creating Parameter and subclasses from XML

## 1.2.3 - 10 November 2011

* Fixed Time#utc_hours_offset to use localtime to preserve TZ info (Earle Clubb)

## 1.2.2 - 29 October 2011

* Fixed polygon parsing and made it consistent across versions

## 1.2.1 - 27 October 2011

* Fixed bug initialising 'audience' attribute in Info class 
* Added CAP/Atom files from Google CAP Library project into specs 
* Organised extension code into separate file
* Modifed RCAP::Alert.from_xml to auto-detect the XML namespace and CAP version. Will default to CAP 1.2 if no namespace is found.

## 1.2.0 - 17 July 2011

* CAP 1.1 and CAP 1.2 - Resource#dereference_uri! fetches data from Resource#uri and sets Resource#deref_uri 
* Resource#deref_uri= will also automatically set size and calculate SHA1 digest
* Resources correctly deal with size on import and export

## 1.1.1 - 25 June 2011

* Documentation and code cleanup 

## 1.1.0 - 20 June 2011

* Added CAP 1.0 Support

## 1.0.1 - 22 April 2011

* Added RCAP::Alert.from_h

## 1.0.0 - 6 April 2011

* Added CAP 1.2 Support
* Added namespaces (RCAP::CAP_1_1 and RCAP::CAP_1_2) to seperate CAP 1.1 and CAP 1.2 classes
* Moved to RSpec2 and Bundler
* Added factory methods to create Info, Resource, Area and Polygon objects from their parents 
* Added factory methods to RCAP::Alert module to parse in files and return the correct RCAP objects
* Pretty print XML and JSON output

## 0.4 - 6th March 2011

* Implemented Hash generation and parsing
* Implemented JSON generation and parsing
* Circle is now a subclass of Point

## 0.3 - 26th November 2009

* Bugfix release

## 0.2 - 20th November 2009

* Implemented to_s/inspect methods for all classes
* Implemented YAML generation and parsing
* Documentation improvements

## 0.1 - 5th November 2009

* Initial release                                                                                                                                                                                               