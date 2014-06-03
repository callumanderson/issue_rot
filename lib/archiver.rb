class Archiver
  attr_accessor :html_path
  attr_accessor :log_path

  def initialize
    @log_path = File.dirname(__FILE__) + '/../../../../log'
    @html_path = File.dirname(__FILE__) + '/../../../html_log'
  end

  def archive_issue(issue)
    LOG.info "Archiving #{issue}"
    log_info = "Issue Expired: #{issue}"
    html_info = "<p>Expired issue: <a href='#{$JIRA_HOST}:#{$JIRA+PORT}/browse/#{issue}'>#{issue}</a></p>"
    @file = File.open(@log_path, 'a') {|f| f << "#{log_info}\n" }
    @file = File.open(@html_path, 'a') {|f| f << "#{html_info}\n" }
  end
end
