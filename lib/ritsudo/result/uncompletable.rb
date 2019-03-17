module Ritsudo
  module Result
    module Uncompletable
      def add(request)
        @requests ||= []
        @uncompleted ||= Hash.new
        @requests << request.url
        @uncompleted[request.url] ||= 0
        if request.time
          @completed[request.url] << request.time
        else
          @uncompleted[request.url] += 1
        end
      end

      def name
        raise NotImplementedError
      end

      def report
        puts "[#{name}]"
        table_data = []
        (@requests || []).uniq.each do |url|
          if @completed[url] && !@completed[url].empty?
            avg   = (@completed[url].sum(0.0) / @completed[url].length).round(2)
            max   = @completed[url].max.round(2)
            min   = @completed[url].min.round(2)
            count = @completed[url].size
          else
            avg = max = min = count = "-"
          end

          table_data << {
            url:           url[0..100],
            avg:           avg,
            max:           max,
            min:           min,
            count:         count,
            uncompleted: @uncompleted[url]
          }
        end
        Formatador.display_table(table_data, [:url, :avg, :max, :min, :count, :uncompleted])
      end
    end
  end
end
