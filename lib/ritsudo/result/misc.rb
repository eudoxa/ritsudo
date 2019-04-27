module Ritsudo
  module Result
    class Misc
      def initialize
        @misc = {}
      end

      def add(group, name, value)
        @misc[group] ||= {}
        @misc[group][name] ||= []
        @misc[group][name] << value
      end

      def report(outliters_stdev_multiple: nil)
        table_data = []
        @misc.each do |group, name_and_values|
          puts "[#{group}]"

          name_and_values.each do |name, all_values|
            use_remove_outsiders = outliters_stdev_multiple && all_values.size > 1
            if use_remove_outsiders
              values = Ritsudo::Result::Helper.remove_outliters(all_values, outliters_stdev_multiple)
            else
              values = all_values
            end

            result = {
              name: name,
              avg: (values.sum(0.0) / values.length)&.round(2),
              max: values.max&.round(2),
              min: values.min&.round(2),
              count: values.size,
              outsiders: all_values.size - values.size
            }


            table_data << result
          end
          Formatador.display_table(table_data, [:name, :avg, :max, :min, :count, :outsiders])
        end
      end
    end
  end
end
