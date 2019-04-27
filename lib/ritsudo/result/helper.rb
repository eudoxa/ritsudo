module Ritsudo
  module Result
    module Helper
      def self.remove_outliters(values, stdev_multiple)
        stdev = standard_deviation(values)
        mean = mean(values)
        range = (mean - (stdev * stdev_multiple))..(mean + (stdev * stdev_multiple))
        values.select { |v| range.cover?(v) }
      end

      def self.mean(values)
        sum = values.sum(0.0)
        mean = sum / values.size
      end

      def self.variance(values)
        total = values.inject(0) { |sum, v| sum + ((v - mean(values)) ** 2) }
        total.to_f / (values.size - 1)
      end

      def self.standard_deviation(values)
        Math.sqrt(variance(values))
      end
    end
  end
end
