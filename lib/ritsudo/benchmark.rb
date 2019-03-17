module Ritsudo
  class Benchmark
    attr_reader :collector
    def initialize(collector: Ritsudo::Collector.new)
      @collector = collector
    end

    def do(url, count: 5, wait: 1, sub_process_timeout: 3, 
                driver_options: {
                   timeout: 5,
                   wait_time: 1
                })
      puts "Ritsudo requests #{count} times: #{url}"
      count.times do
        print(".")
        collect(url, wait: wait, sub_process_timeout: sub_process_timeout, driver_options: driver_options)
      end
      puts ""
    end

    def collect_requests_wait_finish(driver, sub_process_timeout:)
      messages = driver.manage.logs.get('performance')
      requests = Ritsudo::Request.grouping(messages)
      Timeout.timeout(sub_process_timeout) do
        while requests.find(&:processing?)
          sleep(0.5)
          messages = driver.manage.logs.get('performance') + messages
          requests = Ritsudo::Request.grouping(messages)
        end
      end
      requests
    rescue Timeout::Error
      requests
    end

    def drive(driver_options, &block)
      driver = Ritsudo::Driver.new(driver_options)
      yield(driver)
      driver.driver.close()
    end

    def collect(url, wait:, sub_process_timeout:, driver_options:)
      drive(driver_options) do |driver|
        driver.get(url)
        sleep(wait)
        sleep(1) until driver.driver.execute_script("return window.performance.timing.loadEventEnd")

        requests = collect_requests_wait_finish(driver, sub_process_timeout: sub_process_timeout)
        @collector.add(requests)

        dom_content_loaded_script = "return window.performance.timing.domContentLoadedEventEnd - window.performance.timing.requestStart"
        dom_content_loaded = driver.driver.execute_script(dom_content_loaded_script)
        @collector.add_misc("Misc", "DomContentLoaded", dom_content_loaded)

        loaded_script = "return window.performance.timing.loadEventEnd - window.performance.timing.requestStart"
        loaded = driver.driver.execute_script(loaded_script)
        @collector.add_misc("Misc", "Loaded", loaded)
      end
    end
  end
end
