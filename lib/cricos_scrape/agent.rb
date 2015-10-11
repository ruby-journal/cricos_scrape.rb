require 'mechanize'

module CricosScrape
  def self.agent
    agent = Mechanize.new
    agent.user_agent = Mechanize::AGENT_ALIASES['Windows IE 6']
    agent
  end
end
