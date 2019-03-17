# Ritsudo

CLI bnechmark tool based on headless chrome.
Also measure ajax requests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ritsudo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ritsudo

## Usage
```ruby
#!/usr/bin/env ruby
require "bundler/setup"
require "ritsudo"

collector = Ritsudo::Collector.new(match: /example\.com/)
benchmark = Ritsudo::Benchmark.new(collector: collector)
benchmark.do("http:/www.example.com")

benchmark.collector.documents.display
benchmark.collector.xhrs.display
```

```
[Document]
  +--------------------------+--------+--------+--------+-------+
  | url                      | avg    | max    | min    | count |
  +--------------------------+--------+--------+--------+-------+
  | http://www.example.com/  | 597.56 | 858.15 | 433.51 | 5     |
  +--------------------------+--------+--------+--------+-------+
[XHR]
  +------------------------------------------+---------+---------+---------+-------+-------------+
  | url                                      | avg     | max     | min     | count | uncompleted |
  +------------------------------------------+---------+---------+---------+-------+-------------+
  | http://www.example.com/xhr_request       | 300.39  | 500.39  | 250.39  | 4     | 1           |
  +------------------------------------------+---------+---------+---------+-------+-------------+
  | http://www.example.com/slow_xhr_request  | -       | -       | -       | -     | 5           |
  +------------------------------------------+---------+---------+---------+-------+-------------+
```
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
