class ApiController < ApplicationController

  skip_before_filter  :verify_authenticity_token
	require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

@urlx=""

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.yaml")
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

def authorize
  
end

	def algo
		

	end

  def create

  
  end

  

  def add
    
 

  end

  def remove
    require "slack"

Slack.configure do |config|
  config.token = "xoxb-52247322450-zJW8iLrIPFMHfg6FD4tXbhWE"
end


client = Slack::RealTime::Client.new

client.on :hello do
  puts 'Successfully connected.'
end


client.on :message do |data|
  case data['text']
  when 'bot hi' then
    client.message channel: data['channel'], text: "Hi <@#{data['user']}>!"
  when /^bot/ then
    client.message channel: data['channel'], text: "Sorry <@#{data['user']}>, what?"
  end
end



client.start!
  end


end
