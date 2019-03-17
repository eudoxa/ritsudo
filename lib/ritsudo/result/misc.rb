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

      def report
        table_data = []
        @misc.each do |group, name_and_values|
          puts "[#{group}]"
          name_and_values.each do |name, values|
            table_data << {
              name: name,
              avg: (values.sum(0.0) / values.length).round(2),
              max: values.max.round(2),
              min: values.min.round(2),
              count: values.size
            }
          end
          Formatador.display_table(table_data, [:name, :avg, :max, :min, :count])
        end
      end
    end
  end
end
