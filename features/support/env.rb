require 'httparty'
require 'time'
require File.dirname(__FILE__) + '/../../lib/issue-rot'
require File.dirname(__FILE__) + '/../../lib/log-helper'
require File.dirname(__FILE__) + '/../../lib/archiver'
include MiniTest::Assertions

LOG = Log.new(STDOUT)
LOG.datetime_format = '%Y-%m-%d %X' # simplify time output
LOG.level = Log::DEBUG

Before do |scenario|
  @position=0
  case scenario
    when Cucumber::Ast::OutlineTable::ExampleRow
      LOG.info "Scenario: #{scenario.scenario_outline.name.to_s.upcase.red.bold}"
      @steps = find_steps(scenario.scenario_outline)
    when Cucumber::Ast::Scenario
      LOG.info "Scenario: #{scenario.name.to_s.upcase.red.bold}"
      @steps = find_steps(scenario)
    else
      raise('Unhandled class')
  end

  LOG.info "Step #{@position+1}: #{(@steps[@position][2..3].join.blue.bold)}"
  @position+=1
end

def find_steps(scenario)
  i = []
  scenario.to_sexp.each do |index|
    if index.class.name == "Array"
      i<< index if index[0] == :step_invocation || index[0] == :step
    end
  end
  i
end


