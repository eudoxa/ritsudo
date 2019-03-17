module Ritsudo
  class Message
    attr_reader :message

    def self.wrap(raw_messages)
      messages = raw_messages.map { |raw|
        JSON.parse(raw.message)["message"]
      }.reject { |message|
        message["method"] == "Network.dataReceived" # don't use received info
      }
      messages.map { |message| Ritsudo::Message.new(message) }
    end

    def initialize(message)
      @message = message
    end

    def method
      message["method"]
    end

    def timestamp
      param('timestamp')
    end

    def url
      param("request")&.[]("url") || 'none'
    end

    def params
      message["params"]
    end

    def param(name)
      params&.[](name)
    end
  end
end
