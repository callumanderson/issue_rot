require_relative('lib-require')
require 'minitest/autorun'

LOG = Log.new(STDOUT)
LOG.datetime_format = '%Y-%m-%d %X' # simplify time output
LOG.level = Log::DEBUG

#Declare a test instance here
