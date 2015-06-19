namespace :export do
  desc "Print out links to all whitelisted users"
  task all: :environment do
    puts "<dl>"
    WhitelistUser.all_channels.each_pair do |key, val|
      puts "<dt>Channel: #{key}</dt>"
      puts "<dd><a href='http://abovewater.io/ch/#{key}'>http://abovewater.io/ch/#{key}</a></dd>"
      puts "<dd><a href='http://abovewater.io/ch/#{key}/list'>http://abovewater.io/ch/#{key}/list</a></dd>"
      puts "<dd>Members:"
      val.each do |user|
        puts "<dl>"
        puts "<dt>#{user}</dt>"
        puts "<dd><a href='http://abovewater.io/u/#{user}'>http://abovewater.io/u/#{user}</a></dd>"
        puts "<dd><a href='http://abovewater.io/u/#{user}/list'>http://abovewater.io/u/#{user}/list</a></dd>"
        puts "</dl>"
      end
      puts "</dd>"
    end
    puts "</dl>"
  end

end
