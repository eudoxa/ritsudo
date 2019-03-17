module Ritsudo
  module Result
    class Base
      def initialize
        @completed = Hash.new { |h,k| h[k] = [] }
      end

      def add_multiple(requests)
        requests.each { |request| add(request) }
      end

      def add(request)
        raise NotImplementedError
      end
    end
  end
end
