require 'json'
require 'httparty'
require_relative('lib-require')
require 'minitest/autorun'
require 'time'
include MiniTest::Assertions

#TODO: Add email notifications if users want them

class Issue_rot
  attr_accessor :auth
  attr_accessor :req_path
  attr_accessor :host

  def initialize(username, password, req_path, server, port)
    @auth = {:username => username, :password => password}
    @host = "http://" + server + ":" + port
    @req_path = req_path
  end

  def connect
  req = URI.escape(@req_path)
  @resp = HTTParty.get(
      "#{@host}#{req}",
      :basic_auth => @auth
  )
  end

  def get_response_code
    connect
    @resp.code.to_s
  end

  def get_issues
    connect
    if get_response_code =~ /20[0-9]/
      issues_json = JSON.parse(@resp.body)
      issues = Array.new
      assert_equal((issues_json.instance_of? Hash), true)
      issues_json = issues_json["issues"]
      issues_json.each do |issue|
        issues.push(issue["key"])
      end
      issues
    end
  end

  def expire_issues(issue_array)
    arch = Archiver.new
    issue_array.each do |issue|
      LOG.info "Closing issue: #{issue}"
      create_post(issue)
      LOG.info "Done closing issue: #{issue}"
      LOG.info "Archiving issue"
      arch.archive_issue(issue)
    end
  end

  def create_post(issue)
    @req_path = "/rest/api/2/issue/#{issue}/transitions"
    LOG.info "Request path is #{@req_path}"
    LOG.info "Full URI is #{host}#{req_path}"
    HTTParty.post("#{host}#{req_path}",
                  :body => {
                      :update => {
                          :comment => [
                              :add => {
                                  :body => "Ticket closed by new expiry bot at #{Time.now.utc}"
                              }
                          ]
                      },
                      :fields => {
                          :resolution => {
                              :name => "Expired"
                          }
                      },
                      :transition => {
                          :id => "2"
                      }
                  }.to_json,
                  :headers => {"Content-Type" => "application/json"},
                  :basic_auth => @auth)
  end
end