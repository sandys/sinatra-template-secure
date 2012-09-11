require 'rubygems'
require 'sinatra'
require 'uuidtools'
require 'rack/session/pool'

class App < Sinatra::Base

  use Rack::Session::Pool, :expire_after => 2592000, :user_id => "sss"
  #use Rack::Session::PersistentSessions, 'sqlite://blog.db'
  #use Rack::Session::Persistent
  #enable :sessions

  def call(env)
    #global logging
    puts "startup = #{settings.time_at_startup} vs #{Time.now}"
    puts 'manager: ' + env['REQUEST_METHOD'] + ' ' + env['REQUEST_URI']
    #super calls the "get", "post", etc. functions
    status, headers, body = super
    headers['X-Middleware'] = 'true'
    [status, headers, body]
  end
  
  configure :development do
    self.settings.reset!
  end

  get "/" do
    session[:session_id] = UUIDTools::UUID.timestamp_create.to_s
    puts "coming to sss4"
     #r = Rack::Response.new("SSS")
     response.set_cookie "user_id", {:value => "sss", 
                                :expires => (Time.now + 52*7*24*60*60)}
     response.headers['X-SSS'] = "SSS"
     response.body = "SSS"

     response.finish
  end

end

