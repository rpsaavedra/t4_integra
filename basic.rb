require "slack"

Slack.configure do |config|
  config.token = "xoxb-52247322450-o0rkP2VSiHZSsBcHgMbMzafk"
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