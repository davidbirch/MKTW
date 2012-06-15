require 'rubygems'
require 'daemons'

#Daemons.run("./#{File.dirname(__FILE__)}/get_tweets.rb")
Daemons.run("#{File.dirname(__FILE__)}/get_tweets.rb")