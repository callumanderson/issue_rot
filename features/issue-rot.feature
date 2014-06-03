Feature: Issue rot
In order to close old issues
As a QA
I want to have an issue closing bot

Scenario: Connecting to JIRA
When I connect to JIRA with correct credentials
Then the http code should be 200

Scenario: Incorrect Credentials
When I connect to JIRA with incorrect credentials
Then the http code should be 401

Scenario: Fetching candidate issues
When I connect to JIRA with correct credentials
Then I should be returned a list of candidate issues

@reopen_issue
Scenario: Closing candidate issues
Given a single candidate issue
When I close the issue
Then the issue should be closed

@cleanup_test_files
Scenario: Archiving details of expired issues
Given a single candidate issue
When I log the issue
Then the issue details should be logged
