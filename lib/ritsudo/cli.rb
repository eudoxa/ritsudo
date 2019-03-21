require "ritsudo"
require 'thor'
module Ritsudo
  class Cli < Thor
    default_command :benchmark
    option :url, required: true, aliases: ['-a']
    option :count, default: 5, type: :numeric, aliases: ['-c']
    option :sub_process_timeout, default: 5, type: :numeric, aliases: ['-s']
    option :timeout, default: 10, type: :numeric, aliases: ['-t']
    option :wait_time, default: 1, type: :numeric, aliases: ['-w']
    option :ua, type: :string, aliases: ['-u']
    option :match, type: :string, aliases: ['-m']
    desc "benchmark URL", "benchmark"
    def benchmark()
      match = options[:match] ? Regexp.new(options[:match]) : nil
      collector =  Ritsudo::Collector.new(match: match)
      benchmark = Ritsudo::Benchmark.new(collector: collector)
      benchmark.do(options[:url],
                   count: options[:count],
                   sub_process_timeout: options[:sub_process_timeout],
                   driver_options: {
                     timeout: options[:timeout],
                     wait_time: options[:wait_time],
                     user_agent: options[:ua]
                   }
                  )
      benchmark.collector.report
    end
  end
end
