# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file .env file.

testers = [
  'rjacoby',
  'rchoi',
  'joncipriano',
  'sethrobot',
  'donkeyattack',
  'sanjm',
  '_superted',
  'kayvz',
  'sportscenter'
]

testers.each do |handle|
  WhitelistUser.create(handle: handle.downcase, channel: 'testers')
end

cannes_hosts = [
  'Cannes_Lions',
  'ROBBYJAYALA',
  'JackBethmann',
  'Sayhop',
  'cody'
]

cannes_hosts.each do |handle|
  WhitelistUser.create(handle: handle.downcase, channel: 'cannes')
end


upandaway = [
  'TweetSuite_Cannes',
  'TwitterBeach_Cannes',
  'TwitterBeach_CannesLions',
  'Twitter_CannesLions',
  'Twitter_Cannes'
]

upandaway.each do |handle|
  WhitelistUser.create(handle: handle.downcase, channel: 'upandaway')
end

cannes_tweeps = [
  'hoff'
]

cannes_tweeps.each do |handle|
  WhitelistUser.create(handle: handle.downcase, channel: 'tweeps')
end
