module Ritsudo
  class Request
    attr_reader :messages
    attr_reader :request_id

    def self.grouping(raw_messages)
      messages = Ritsudo::Message.wrap(raw_messages)
      requests = messages.group_by { |message|
        message.param('requestId')
      }.map { |request_id, messages|
        Ritsudo::Request.new(request_id, messages)
      }
      requests
    end

    def initialize(request_id, messages)
      @request_id = request_id
      @messages = messages
    end

    def time
      return nil unless received_message && sent_message
      ((received_message.timestamp - sent_message.timestamp) * 1000) # msec
    end

    def url
      if _url = sent_message&.url
        url = URI.parse(_url)
        "#{url.scheme}//#{url.host}#{url.path}"
      else
        nil
      end
    end

    def processing?
      sent_message && !finished_message
    end

    def sent_message
      @messages.find { |message| message.method == "Network.requestWillBeSent" }
    end
    private :sent_message

    def finished_message
      @messages.find { |event| event.method == "Network.loadingFinished" }
    end
    private :finished_message

    def received_message
      @messages.find { |event| event.method == "Network.responseReceived" }
    end
    private :received_message

    def type
      sent_message&.param("type") || 'etc'
    end
  end
end
