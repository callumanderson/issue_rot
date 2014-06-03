Given /^a single candidate issue$/ do
  @test_issue = "QA-287"
  @issue_array = Array.new
  @issue_array.push(@test_issue)
end

When /^I close the issue$/ do
  assert_instance_of Array, @issue_array
  @issue_rot = Issue_rot.new(
      $JIRA_USER,
      $JIRA_PASSWORD,
      "/rest/api/2/issue/#{@issue_array.first}/transitions",
      $JIRA_HOST,
      $JIRA_PORT,
  )
  @issue_rot.expire_issues(@issue_array)
  @issue_array.each do |elem|
    p "Expiring issue: <a href=#{$JIRA_HOST}:#{$JIRA_PORT}/browse/#{elem}'>#{elem}</a>"
  end
end

When /^I connect to JIRA with correct credentials$/ do
  @issue_rot = Issue_rot.new(
      $JIRA_USER,
      $JIRA_PASSWORD,
      "/rest/api/2/search?jql=updated<=-100d AND status!=closed&tempMax=1000",
      $JIRA_HOST,
      $JIRA_PORT,
  )
end

When /^I connect to JIRA with incorrect credentials$/ do
  @issue_rot = Issue_rot.new(
      $JIRA_USER,
      "incorrect",
      "/rest/api/2/search?jql=updated<=-100d AND status!=closed&tempMax=1000",
      $JIRA_HOST,
      $JIRA_PORT,
  )
end

Then /^I should be returned a list of candidate issues$/ do
  issues_array = @issue_rot.get_issues
  assert_equal((issues_array.instance_of? Array), true, msg="get_issues did not return an array #{issues_array.class.name}" )
  LOG.info "First issue in the array is #{issues_array.first}"
  #Check the full element e.g. /WWW-[0-9{3}]/
  assert(issues_array.first =~ /.*[0-9{3}]/)
end

Then /^the http code should be (.*)$/ do |code|
  LOG.info "Then the http code should be #{code}"
  assert_equal(code, @issue_rot.get_response_code)
end

Then /^the issue should be closed$/ do
  assert_equal(check_issue_state["id"], "6")
  assert_equal(check_issue_state["description"], "Expired")
end

When /^I log the issue$/ do
  arch = Archiver.new()
  arch.log_path = File.dirname(__FILE__) + '/../../docs/test_log'
  arch.html_path = File.dirname(__FILE__) + '/../../docs/test_html_log'
  arch.archive_issue(@test_issue)
end

Then /^the issue details should be logged$/ do
  log = File.dirname(__FILE__) + '/../../docs/test_log'
  html = File.dirname(__FILE__) + '/../../docs/test_html_log'
  assert_equal((File.open(log).read.include? @test_issue), true)
  assert_equal((File.open(html).read.include? @test_issue), true)
end

def check_issue_state
  auth = {:username => $JIRA_USER, :password => $JIRA_PASSWORD}
  req =  "#{$JIRA_HOST}:#{$JIRA_PORT}/rest/api/2/issue/" + @test_issue
  resp = HTTParty.get(req, :basic_auth => auth)
  json = JSON.parse(resp.body)
  json["fields"]["resolution"]
end
