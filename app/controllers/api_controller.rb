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
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'liiro'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    @urlx=url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  puts "kik kik ik"
  puts "kik kik ik"
  credentials
end


 def algo
    eventos = Array.new

    puts "primero xxxx "
    service = Google::Apis::CalendarV3::CalendarService.new
    puts "segundo xxxx "
    service.client_options.application_name = APPLICATION_NAME
    puts "tercero xxxx "
    service.authorization = authorize
    puts "cuarto xxxx "

    # Fetch the next 10 events for the user
    calendar_id = 'primary'
    puts "quito xxxx "
    response = service.list_events("avv8qa6cq84060r3nd2teussls@group.calendar.google.com",
                                   max_results: 10,
                                   single_events: true,
                                   order_by: 'startTime')

    puts "Upcoming events:"
    puts "No upcoming events found" if response.items.empty?
    @hola="No upcoming events found" if response.items.empty?

    response.items.each do |event|
      start = event.start.date || event.start.date_time
      hola= "- #{event.summary} (#{start})"
      eventos.push(event)
      puts "- #{event.summary} (#{start})"

    end
    return eventos
  end

  def create
    idx = params[:id]
    puts "aaaaaa  xddxdxd"
    puts idx
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(
      client_id, SCOPE, token_store)
    user_id = 'loolff'
    credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    
    if(idx=="0")
      puts "hahahaha haha jahah"
      url = authorizer.get_authorization_url(
      base_url: OOB_URI)
     @algo= url
    else
      #puts "Open the following URL in the browser and enter the " +
      #     "resulting code after authorization"
      #puts url
      #@urlx=url
      code = "4/" + idx
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI)
      @algo= "listo" 
    end
  end
  
  
    end



    def lol
      return @toto
    end
  

  def add
    #scopes =  ['https://www.googleapis.com/auth/calendar']
    #authorization = Google::Auth.get_application_default("https://www.googleapis.com/auth/calendar")

    # Clone and set the subject
    #auth_client = authorization.dup
    #auth_client.sub = 'user@example.org'


    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = authorize
    event = Google::Apis::CalendarV3::Event.new(
      summary: 'Google I/O 2015',
      location: '800 Howard St., San Francisco, CA 94103',
      description: 'A chance to hear more about Google\'s developer products.',
      start: {
        date_time: '2016-06-28T09:00:00-07:00',
        time_zone: 'America/Santiago',
      },
      end: {
        date_time: '2016-06-28T17:00:00-07:00',
        time_zone: 'America/Santiago',
      },
      recurrence: [
        'RRULE:FREQ=DAILY;COUNT=2'
      ]
    )


    result = service.insert_event('avv8qa6cq84060r3nd2teussls@group.calendar.google.com', event)
    puts "Event created: #{result.html_link}"

  end

  def remove
    require "slack"

    Slack.configure do |config|
      config.token = ENV['TOKEN_SLACK']
      
      
    end


    client = Slack::RealTime::Client.new

    client.on :hello do
      puts 'Successfully connected.'
    end


    client.on :message do |data|
      

      case data['text']
      when 'eventos?' then
        eventos = algo()
        puts "hahahah"
        eventos.each do |ev|
          start = ev.start.date || ev.start.date_time
          hola= "- #{ev.summary} (#{start})"
          client.message channel: data['channel'], text: "<@#{data['user']}>! :"+hola
        end
      when 'url?' then
        client.message channel: data['channel'], text: "<@#{data['user']}>, https://calendar.google.com/calendar/embed?src=avv8qa6cq84060r3nd2teussls%40group.calendar.google.com&ctz=America/Santiago"
      when 'crear' then
        add
        client.message channel: data['channel'], text: " <@#{data['user']}>, Listoco"
      when /^bot/ then

        client.message channel: data['channel'], text: "Sorry <@#{data['text']}>, what?"
      end
    end

    puts "aaaaaaaaaaaaaaaaaa"

    client.start!
    puts "oooooooooooooooooooooooooollllllllllllllllll"
  end


end
