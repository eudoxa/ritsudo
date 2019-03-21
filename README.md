# Ritsudo

CLI bnechmark tool based on headless chrome.
Also measure ajax requests.

## Installation

Add this line to your application's Gemfile:

install it yourself as:

    $ gem install ritsudo

## Usage
### CLI
```
ritsudo -a=https://example.com -m "example.com" -u "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25"
```

### Ruby
```ruby
#!/usr/bin/env ruby
require "bundler/setup"
require "ritsudo"

ua = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25"
collector = Ritsudo::Collector.new(match: /example\.com/)
benchmark = Ritsudo::Benchmark.new(collector: collector)
benchmark.do("http:/www.example.com", driver_options: {
              user_agent: ua
             })

benchmark.collector.documents.display
benchmark.collector.xhrs.display
```

### Result
```
[Misc]
  +------------------+--------+------+-----+-------+
  | name             | avg    | max  | min | count |
  +------------------+--------+------+-----+-------+
  | DomContentLoaded | 858.6  | 921  | 797 | 5     |
  +------------------+--------+------+-----+-------+
  | Loaded           | 1235.6 | 1672 | 975 | 5     |
  +------------------+--------+------+-----+-------+
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
[Script]
  +--------------------------------+-------+-------+-------+-------+-------------+
  | url                            | avg   | max   | min   | count | uncompleted |
  +--------------------------------+-------+-------+-------+-------+-------------+
  | https//example.com/example.js  | 25.88 | 43.15 | 14.96 | 5     | 0           |
  +--------------------------------+-------+-------+-------+-------+-------------+
```
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
