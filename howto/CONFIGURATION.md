### Recognized keys and values
* __`threads`__

	Number of threads to spawn.
	* Recognized values: Integers
	* Default value: `4`

* __`user_agent`__

	Number of threads to spawn.
	* Recognized values: Strings
	* Default value: `"Schablone"`

* __`http_adapter`__

	Which HTTP adapter to use.
	* Recognized values: `:net_http`, `:selenium`
	* Default value: `:net_http`

* __`selenium_argv`__

	Argument vector passed to `Selenium::WebDriver::for`.
	* Recognized values: [See documentation](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
	* Default value: `[:firefox]`

* __`log_level`__

	Minimum level of log messages to print.
	* Recognized values: [See documentation](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
	* Default value: `Logger::WARN`
	* Note: You can bring your own logger with `Schablone::logger=`

* __`sanitize_node_content`__

	Whether to trim leading/trailing whitespace and control characters from inner HTML/XML.
	* Recognized values: Booleans
	* Default value: `true`
	* Note: Only applies when using `Schablone::Extraction`.

* __`ignore_fragment_identifiers`__

	Whether to treat URIs with only differing fragment identifiers as equal.
	* Recognized values: Booleans
	* Default value: `true`

* __`max_http_redirects`__

	Number of HTTP redirects to follow per initial request.
	* Recognized values: Integers
	* Default value: `3`
	* Note: Has no effect when using Selenium.

* __`obey_robots_txt`__

	Whether to obey `robots.txt`.
	* Recognized values: Booleans
	* Default value: `false`

* __`nokogiri_parsing_options`__

	A Proc that gets bound when calling `Nokogiri::HTML`/`Nokogiri::XML` and is passed an instance of `Nokogiri::XML::ParseOptions`.
	* Recognized values: Procs, [see documentation](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/ParseOptions)
	* Default value: `-> (config) {}`
	
* __`oj_parsing_options`__

	A `Hash` that gets passed to `Oj::load`
	* Recognized values: Hashes, [see documentation](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/ParseOptions)
	* Default value: `{}`

* __`mustermann_pattern_type`__

	Which pattern type to use when matching URI paths.
	* Recognized values: Symbols, [see documentation](https://github.com/rkh/mustermann#pattern-types)
	* Default value: `:template`
	* Note: Mustermann is a MRI-only dependency.

### Optional MRI-only dependencies
#### Mustermann
`require "mustermann"` if you want to match URI path segments.

#### oj
`require "oj"` if you want faster JSON parsing.

#### Pismo
`require "pismo"` if you want out-of-the-box metadata extraction. See [Extracting metadata with Pismo]().
