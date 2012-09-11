require 'rubygems'
require 'sinatra'
require 'uuidtools'
require 'rack/session/pool'

class App < Sinatra::Base

  use Rack::Session::Pool, :expire_after => 2592000, :user_id => "sss"
  #use Rack::Session::PersistentSessions, 'sqlite://blog.db'
  #use Rack::Session::Persistent
  #enable :sessions
  
  configure :development do
    self.settings.reset!
  end

  get "/" do
    session[:session_id] = UUIDTools::UUID.timestamp_create.to_s
    puts "coming to sss4"
     r = Rack::Response.new("SSS")
     r.set_cookie "user_id", {:value => "sss", 
                                :expires => (Time.now + 52*7*24*60*60)}
     r.finish
  end

end

