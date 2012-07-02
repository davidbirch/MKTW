require 'rubygems'
require 'daemons'

Daemons.run("#{File.dirname(__FILE__)}/parse_tweets.rb")