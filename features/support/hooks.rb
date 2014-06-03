After('@reopen_issue') do
  LOG.info "Reopening test issue"
  auth = {:username => $JIRA_USER, :password => $JIRA_PASSWORD}
  HTTParty.post($JIRA_HOST + "/rest/api/2/issue/QA-287/transitions",
                       :body => {
                           :update => {
                               :comment => [
                                   :add => {
                                       :body => "Ticket re-opened by new expiry bot at #{Time.now.utc}"
                                   }
                               ]
                           },
                           :transition => {
                               :id => "711"
                           }
                       }.to_json,
                       :headers => { "Content-Type" => "application/json" },
                       :basic_auth => auth)
  LOG.info "Done reopening test issue"
end

After('@cleanup_test_files') do
  log = File.dirname(__FILE__) + '/../../docs/test_log'
  html = File.dirname(__FILE__) + '/../../docs/test_html_log'
  File.truncate(log, 0)
  File.truncate(html, 0)
end
