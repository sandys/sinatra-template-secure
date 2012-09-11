require 'rubygems'
require 'sinatra'

class App < Sinatra::Base

  #use Rack::Session::Pool
  #use Rack::Session::PersistentSessions, 'sqlite://blog.db'
  use Rack::Session::Persistent
  
  configure :development do
    self.settings.reset!
  end

  get "/" do
    puts "coming to sss4"
  end

end

