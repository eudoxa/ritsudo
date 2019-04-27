# Ritsudo

CLI bnechmark tool based on headless chrome.
Also measure ajax requests.

## Installation

install it yourself as:

    $ gem install ritsudo

## Usage
### CLI
```
ritsudo -a https://example.com -m "example.com" -u "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1"
```

### Ruby
```ruby
#!/usr/bin/env ruby
require "bundler/setup"
require "ritsudo"

ua = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1"
collector = Ritsudo::Collector.new(match: /example\.com/)
benchmark = Ritsudo::Benchmark.new(collector: collector)
benchmark.do("https:/www.example.com", driver_options: { user_agent: ua })
benchmark.collector.documents.display
benchmark.collector.xhrs.display
```

### Result
```
Ritsudo requests 5 times: https://example.com
.....
[Misc]
  +------------------+--------+------+-----+-------+
  | name             | avg    | max  | min | count |
  +------------------+--------+------+-----+-------+
  | DomContentLoaded | 858.6  | 921  | 797 | 5     |
  +------------------+--------+------+-----+-------+
  | Loaded           | 1235.6 | 1672 | 975 | 5     |
  +------------------+--------+------+-----+-------+

[Document]
  +---------------------------+--------+--------+--------+-------+
  | url                       | avg    | max    | min    | count |
  +---------------------------+--------+--------+--------+-------+
  | https://www.example.com/  | 597.56 | 858.15 | 433.51 | 5     |
  +---------------------------+--------+--------+--------+-------+

[XHR]
  +-------------------------------------------+---------+---------+---------+-------+-------------+
  | url                                       | avg     | max     | min     | count | uncompleted |
  +-------------------------------------------+---------+---------+---------+-------+-------------+
  | https://www.example.com/xhr_request       | 300.39  | 500.39  | 250.39  | 4     | 1           |
  +------------------------------------------+---------+---------+---------+-------+-------------+
  | https://www.example.com/slow_xhr_request  | -       | -       | -       | -     | 5           |
  +-------------------------------------------+---------+---------+---------+-------+-------------+

[Script]
  +--------------------------------+-------+-------+-------+-------+-------------+
  | url                            | avg   | max   | min   | count | uncompleted |
  +--------------------------------+-------+-------+-------+-------+-------------+
  | https//example.com/example.js  | 25.88 | 43.15 | 14.96 | 5     | 0           |
  +--------------------------------+-------+-------+-------+-------+-------------+
```

### Set Cookies
```
ritsudo -a https://example.com/page -m "example.com" -C "hoge=fuga"
```

### Remove outlier
-r option removes outliders outside of (stdev * numeric) value.
```
ritsudo -a https://example.com/page -m "example.com" -s #{numeric}
```


#### Problem
Headless chrome doesn't support to set cookies before access.
So, Ritsudo accesses root path(e.g https://example.com) before each benchmark.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
