module Ritsudo
  module Result
    class Scripts < Base
      include Ritsudo::Result::Uncompletable

      def name
        "Script"
      end
    end
  end
end
