require 'selenium-webdriver'
require 'forwardable'

module Ritsudo
  class Driver
    extend Forwardable
    def_delegators :@driver, :get, :get_log, :manage

    def driver
      @driver
    end

    def initialize(logger_level: :warn, timeout: 60, wait_time: 5,
                   logger_output: "./ritsudo.selenium.log",
                   user_agent: nil,
                   args: ['--headless',
                          '--window-size=1920,1080',
                          '--ignore-certificate-errors',
                          '--disable-popup-blocking',
                          '--disable-translate',
                          '--blink-settings=imagesEnabled=false'])

      if user_agent
        args << "--user-agent=#{user_agent}"
      end

      Selenium::WebDriver.logger.output = logger_output
      Selenium::WebDriver.logger.level = logger_level
      client = Selenium::WebDriver::Remote::Http::Default.new.tap { |c| c.read_timeout = timeout }
      @driver = Selenium::WebDriver.for(:chrome, options: options(args),
                                        desired_capabilities: caps,
                                        http_client: client,).tap do |d|
        d.manage.timeouts.implicit_wait = timeout
      end
      #@wait = Selenium::WebDriver::Wait.new(timeout: wait_time)
    end

    def caps
      Selenium::WebDriver::Remote::Capabilities.chrome(
        loggingPrefs: { performance: 'ALL' },
        chromeOptions: {
          perfLoggingPrefs: {
            enableNetwork: true
          }
        }
      )
    end
    private :caps

    def options(args)
      Selenium::WebDriver::Chrome::Options.new(args: args)
    end
    private :options
  end
end
