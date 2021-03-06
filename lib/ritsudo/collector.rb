module Ritsudo
  class Collector
    attr_reader :documents, :xhrs, :scripts

    def initialize(documents: Ritsudo::Result::Documents.new,
                   xhrs:      Ritsudo::Result::Xhrs.new,
                   scripts:   Ritsudo::Result::Scripts.new,
                   misc:      Ritsudo::Result::Misc.new,
                   match:     nil)
      @documents = documents
      @xhrs      = xhrs
      @scripts   = scripts
      @misc      = misc
      @match     = match
    end

    def add(_requests)
      if @match
        requests =_requests.select do |request|
          @match =~ request.url
        end
      else
        requests = _requests
      end

      types = requests.group_by(&:type)
      documents.add_multiple(types["Document"]) if types["Document"]
      xhrs.add_multiple(types["XHR"])           if types["XHR"]
      scripts.add_multiple(types["Script"])     if types["Script"]
    end

    def add_misc(group, name, value)
      @misc.add(group, name, value)
    end

    def report(outliters_stdev_multiple: nil)
      @misc.report(outliters_stdev_multiple: outliters_stdev_multiple)
      puts ""
      @documents.report(outliters_stdev_multiple: outliters_stdev_multiple)
      puts ""
      @xhrs.report(outliters_stdev_multiple: outliters_stdev_multiple)
      puts ""
      @scripts.report(outliters_stdev_multiple: outliters_stdev_multiple)
      puts ""
    end
  end
end
