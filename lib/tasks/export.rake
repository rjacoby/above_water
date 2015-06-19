namespace :export do
  desc "Print out links to all whitelisted users"
  task all: :environment do
    puts "<ul>"
    WhitelistUser.all_channels.each_pair do |key, val|
      puts "<li>Channel: #{key}</li><ul>"
      puts "<li><a href='http://abovewater.io/ch/#{key}'>http://abovewater.io/ch/#{key}</a></li>"
      puts "<li><a href='http://abovewater.io/ch/#{key}/list'>http://abovewater.io/ch/#{key}/list</a></li>"
      puts "<li>Members:"
      val.each do |user|
        puts "<dl>"
        puts "<dt>#{user}</dt>"
        puts "<dd><a href='http://abovewater.io/u/#{user}'>http://abovewater.io/u/#{user}</a></dd>"
        puts "<dd><a href='http://abovewater.io/u/#{user}/list'>http://abovewater.io/u/#{user}/list</a></dd>"
        puts "</dl>"
      end
      puts "</li></ul>"
    end
    puts "</ul>"
  end

end
