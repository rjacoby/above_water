namespace :export do
  desc "Print out links to all whitelisted users as Markdown"
  task all: :environment do
    WhitelistUser.all_channels.each_pair do |key, val|
      puts "- Channel: #{key}"
      puts "  - http://abovewater.io/ch/#{key}"
      puts "  - http://abovewater.io/ch/#{key}/list"
      puts "  - Members:"
      val.each do |user|
        puts "    - #{user}"
        puts "      - http://abovewater.io/u/#{user}"
        puts "      - http://abovewater.io/u/#{user}/list"
      end
    end
  end

end
