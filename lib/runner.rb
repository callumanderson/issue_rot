require_relative('lib-require')
require 'minitest/autorun'

LOG = Log.new(STDOUT)
LOG.datetime_format = '%Y-%m-%d %X' # simplify time output
LOG.level = Log::DEBUG

rotter = Issue_rot.new #Instantiate him with some instance variables based on your jira conf

issues = rotter.get_issues
assert_instance_of Array, issues
LOG.info "There are currently #{issues.size} issues to close"
#test_issues = %w(QA-287)
#rotter.expire_issues(test_issues)
rotter.expire_issues(issues)
LOG.info "Done expiring issues"

