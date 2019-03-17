module Ritsudo
  module Result
    class Documents < Base
      def add(request)
        @completed[request.url] << request.time
      end

      def report
        table_data = []
        puts "[Document]"
        @completed.each do |url, complete|
          table_data << {
            url: url[0..100],
            avg: (complete.sum(0.0) / complete.length).round(2),
            max: complete.max.round(2),
            min: complete.min.round(2),
            count: complete.size
          }
        end
        Formatador.display_table(table_data, [:url, :avg, :max, :min, :count])
      end
    end
  end
end
