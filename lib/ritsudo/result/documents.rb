module Ritsudo
  module Result
    class Documents < Base
      include Ritsudo::Result::Uncompletable
      def name
        "Document"
      end
    end
  end
end
