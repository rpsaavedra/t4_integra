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
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  puts "aaaaaaaaaaaaaaaa"
  puts "aaaaaaaaaaaaaaaa"
  puts client_id
  puts token_store
  puts authorizer
  puts "aaaaaaaaaaaaaaaa"
  puts "aaaaaaaaaaaaaaaa"
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
  credentials
end

	def algo
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
		  @hola= "- #{event.summary} (#{start})"
		  puts "- #{event.summary} (#{start})"
		end

	end

  def create

    fin = {:date => "2016-06-18", :timeZone => "America/Santiago"}
    inicio = {:date => "2016-06-19", :timeZone => "America/Santiago"}
    response = { :end => fin, :start => inicio}
  
    #render :json => response
    orden = HTTP.headers(:"Content-Type" => "application/json").post("https://www.googleapis.com/calendar/v3/calendars/avv8qa6cq84060r3nd2teussls@group.calendar.google.com/events?key={AIzaSyDzQOdQloX6gkYClpEigPBxl9UuIUr3BzA}", :params => response)
    
    #orden = JSON.parse(HTTP.headers(:"Content-Type" => "application/json").post("https://www.googleapis.com/calendar/v3/calendars/avv8qa6cq84060r3nd2teussls@group.calendar.google.com/events?key={AIzaSyDfzHVgj-YBYGnQp6UWW-e3JMF59L08jac}", :params => response).to_s, :symbolize_names => true)
    #orden= JSON.parse(HTTP.headers(:"Content-Type" => "application/json").get("http://mare.ing.puc.cl/oc/obtener/"+idoc).to_s, :symbolize_names => true)
    puts orden
  end

  

  def add
    
   event = Google::Apis::CalendarV3::Event.new{
  summary: 'Google I/O 2015',
  location: '800 Howard St., San Francisco, CA 94103',
  description: 'A chance to hear more about Google\'s developer products.',
  start: {
    date_time: '2015-05-28T09:00:00-07:00',
    time_zone: 'America/Los_Angeles',
  },
  end: {
    date_time: '2015-05-28T17:00:00-07:00',
    time_zone: 'America/Los_Angeles',
  },
  recurrence: [
    'RRULE:FREQ=DAILY;COUNT=2'
  ],
  attendees: [
    {email: 'lpage@example.com'},
    {email: 'sbrin@example.com'},
  ],
  reminders: {
    use_default: false,
    overrides: [
      {method' => 'email', 'minutes: 24 * 60},
      {method' => 'popup', 'minutes: 10},
    ],
  },
}

result = client.insert_event('primary', event)
puts "Event created: #{result.html_link}"

  end

  def remove
  end


end
