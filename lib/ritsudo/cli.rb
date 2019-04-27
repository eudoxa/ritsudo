require "ritsudo"
require 'thor'
module Ritsudo
  class Cli < Thor
    default_command :benchmark
    class_option :url, required: true, aliases: ['-a']
    class_option :count, default: 5, type: :numeric, aliases: ['-c']
    class_option :cookies, type: :string, aliases: ['-C']
    class_option :sub_process_timeout, default: 5, type: :numeric, aliases: ['-s']
    class_option :timeout, default: 10, type: :numeric, aliases: ['-t']
    class_option :wait_time, default: 1, type: :numeric, aliases: ['-w']
    class_option :ua, type: :string, aliases: ['-u']
    class_option :match, type: :string, aliases: ['-m']

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
                     user_agent: options[:ua],
                     cookies: options[:cookies]
                   }
                  )
      benchmark.collector.report
    end
    tasks["benchmark"].options = self.class_options
  end
end
