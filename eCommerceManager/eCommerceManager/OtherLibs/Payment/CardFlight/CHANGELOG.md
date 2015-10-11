### 1.7.1
* Fixed bug with refund amount, now accepts amounts in dollar and cents

### 1.7.0
* Added metadata to charges
* Created new refund method

### 1.6.3
* Added ability to copy and serialize CFTCharge
* Improved deprecation warnings
* Updated documentation

### 1.6.2
* Exposed encrypted swipe data

### 1.6.1
* Created separate static libraries for shuttle and attache readers

### 1.6
* Changed to subspec for Attache reader class (pod 'CardFlight/Attache')
* Changed CardFlight class to CFTSessionManager
* Added Void function

### 1.5.0
* Changed custom manual entry to unified field
* Added manual entry protocol
* Deprecated old version of manual entry
* Added support for NSCopying of CFTCard
* Change readerDelegate to CFTReaderDelegate

### 1.4.0
* Added 64 bit support
* Added flag for attache reader
* Deprecated connect and disconnect methods

### 1.3.0
* Added name field for custom manual entry
* Added text field delegate forwarders for custom manual entry
* Bugfixes

### 1.2

* Added logging mode for debugging
* Added becomeFirstResponder forwarder
* Added textFieldShouldReturn protocol method

### 1.1.3

* Added callback for user cancelled swipe
* Fixed callback for reader timeout
* Fixed ability to change account token

### 1.1.2

* Fixed url encoding of transaction descriptions

### 1.1.1

* Added support for reading swipes from generic cards
* Fixed tokenization card errors

### 1.1.0

* Added support for new readers
* Added support for timeout duration

### 1.0.2

* Fixes bug with errors returning nil

### 1.0.1

* Minor bug fixes

### 1.0.0

* Initial release
