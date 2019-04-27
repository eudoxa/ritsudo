require 'json'
require 'formatador'

require 'ritsudo/version'
require 'ritsudo/driver'
require 'ritsudo/result'
require 'ritsudo/message'
require 'ritsudo/request'
require 'ritsudo/benchmark'
require 'ritsudo/collector'
require 'ritsudo/result'
require 'ritsudo/result/helper'
require 'ritsudo/result/base'
require 'ritsudo/result/uncompletable'
require 'ritsudo/result/misc'
require 'ritsudo/result/documents'
require 'ritsudo/result/xhrs'
require 'ritsudo/result/scripts'

module Ritsudo
  class Error < StandardError; end
end
