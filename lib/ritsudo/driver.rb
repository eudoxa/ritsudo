require 'selenium-webdriver'
require 'forwardable'
require 'webrick/cookie'

module Ritsudo
  class Driver
    extend Forwardable
    def_delegators :@driver, :get_log, :manage

    def driver
      @driver
    end

    def initialize(logger_level: :warn, timeout: 60, wait_time: 5,
                   logger_output: "./ritsudo.selenium.log",
                   user_agent: nil,
                   cookies: nil,
                   args: ['--headless',
                          '--window-size=1920,1080',
                          '--ignore-certificate-errors',
                          '--disable-popup-blocking',
                          '--disable-translate',
                          '--blink-settings=imagesEnabled=false'])

      if user_agent
        args << "--user-agent=#{user_agent}"
      end

      if cookies
        @cookie_templates = WEBrick::Cookie.parse(cookies).map do |cookie|
          { name: cookie.name, value: cookie.value, path: '/' }
        end
      end

      Selenium::WebDriver.logger.output = logger_output
      Selenium::WebDriver.logger.level = logger_level
      client = Selenium::WebDriver::Remote::Http::Default.new.tap { |c| c.read_timeout = timeout }
      driver_options = { options: options(args), desired_capabilities: caps, http_client: client }
      @driver = Selenium::WebDriver.for(:chrome, driver_options).tap do |d|
        d.manage.timeouts.implicit_wait = timeout
      end
      #@wait = Selenium::WebDriver::Wait.new(timeout: wait_time)
    end

    def get(url)
      if @cookie_templates
        u = URI.parse(url)
        base_url = u.to_s.sub(u.request_uri, '/')
        @driver.get(base_url)
        @driver.execute_script("return window.stop");
        sleep(1)
        @driver.manage.logs.get('performance')
        @cookie_templates&.each do |cookie|
          manage.add_cookie(cookie.merge(domain: URI.parse(url).host))
        end
      end
      puts @driver.manage.logs.get('performance').inspect
      @driver.get(url)
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
