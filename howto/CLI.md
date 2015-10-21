# Command-line interface
The gem ships with a small executable, `wayfarer`.
Ruby job classes are loaded by naming convention, e.g. if you pass `./directory/foo_bar.rb` as the `FILE` parameter, that file is expected to define the class `FooBar`. You can leave off the `.rb` extension.

## `wayfarer exec FILE URI`
Runs the job defined in `FILE`, starting from `URI`.

### Recognized options, flags and values
#### `--log_level` (option)
Which log messages to print.

* Default: `info`
* Recognized values: `unknown`, `debug`, `error`, `fatal`, `info`, `warn`

#### `--no_progress` (flag)
Don’t print progress bars.

## `wayfarer enqueue FILE URI`
Loads and enqueues the job in `FILE`, starting from `URI`.

#### `--log_level` (option)
Which log messages to print.

* Default: `info`
* Recognized values: `unknown`, `debug`, `error`, `fatal`, `info`, `warn`

#### `--queue_adapter` (option)
Which ActiveJob queue adapter to use (e.g. `sidekiq`, `resque`).

* Recognized values: strings, see [documentation](http://api.rubyonrails.org/)

#### `--wait` (option)
Point of time when the enqueued job should be run.

1. If the value can be converted to an integer, it represents the seconds from now.
2. If the value can be parsed by `Time::parse`, the job gets scheduled at that point in time.
3. If the value is a human-readable time string that [Chronic](https://github.com/mojombo/chronic) can make sense of, the job is scheduled at that point in time.

__Examples:__

60 seconds from now:

```
wayfarer enqueue ./foo_bar http://google.com --wait 60
```

6pm, today:

```
wayfarer enqueue ./foo_bar http://google.com --wait 18:00
```

Tomorrow:

```
wayfarer enqueue ./foo_bar http://google.com --wait tomorrow
```

## `wayfarer route FILE URI`
Loads the job defined in `FILE`, and prints the first matching route for `URI`.