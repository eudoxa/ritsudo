module Ritsudo
  module Result
    module Uncompletable
      include Ritsudo::Result::Helper

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

      def report(outliters_stdev_multiple: nil)
        puts "[#{name}]"
        table_data = []
        (@requests || []).uniq.each do |url|
          if @completed[url] && !@completed[url].empty?
            all_request_times = @completed[url]
            use_remove_outliters = outliters_stdev_multiple && all_request_times.size > 1

            if use_remove_outliters
              request_times = Ritsudo::Result::Helper.remove_outliters(all_request_times, outliters_stdev_multiple)
            else
              request_times = all_request_times
            end

            avg   = (request_times.sum(0.0) / request_times.length)&.round(2)
            max   = request_times.max&.round(2)
            min   = request_times.min&.round(2)
            count = request_times.size
          else
            avg = max = min = count = "-"
          end

          result = {
            url:         url[0..100],
            avg:         avg,
            max:         max,
            min:         min,
            count:       count,
            uncompleted: @uncompleted[url],
            outliters:   all_request_times.size - request_times.size
          }


          table_data << result
        end
        Formatador.display_table(table_data, [:url, :avg, :max, :min, :count, :uncompleted, :outliters])
      end
    end
  end
end
