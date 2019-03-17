module Ritsudo
  module Result
    class Xhrs < Base
      include Ritsudo::Result::Uncompletable
      def name
        "XHR"
      end
    end
  end
end
