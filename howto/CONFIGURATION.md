# Configuration
Currently, configuration can only bet set globally, i.e. changing a value effects all 

## Recognized keys
See [lib/wayfarer/configuration.rb]().

### `print_stacktraces`
* Default: `true`
* Recognized values: Booleans

Whether to print stacktraces.

### `reraise_exceptions`
* Default: `false`
* Recognized values: Booleans

Whether to crash when encountering unhandled exceptions.

### `allow_circulation`
* Default: `false`
* Recognized values: Booleans

Whether URIs may be visited twice.

__NOTE:__ Allowing circulation can cause your Jobs to not terminate.

### `normalize_uris`
* Default: `true`
* Recognized values: Booleans

Whether trailing slashes and fragment identifiers should be considered insignificant when comparing URIs, e.g. `https://example.com`, `https://example.com/` and `https://example.com#anchor` are considered equal.

### `connection_count`
* Default: `4`
* Recognized values: Integers

How many concurrent HTTP connections/Selenium drivers to use.

### `http_adapter`
* Default: `:net_http`
* Recognized values: `:net_http`, `:selenium`

Which HTTP adapter to use.

### `connection_timeout`
* Default: `5.0`
* Recognized values: Floats

### `max_http_redirects`
* Default: `3`
* Recognized values: Integers

How many 3xx redirects to follow.

__NOTE:__ Has no effect when using Selenium.

### `selenium_argv`
* Default: `[:firefox]`
* Recognized values: [See documentation]()

Argument vector for instantiating Selenium drivers.

### `window_size`
* Default: `[1024, 768]`
* Recognized values: `[Integer, Integer]`

Dimensions of browser windows.

__NOTE:__ Only applies to Selenium drivers.

### `mustermann_type`
* Default: `:sinatra`
* Recognized values: [See documentation]()

Which Mustermann pattern type to use when matching URI paths.