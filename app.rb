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
    puts "d - > #{headers}"
    Rack::Utils.set_cookie_header! headers, :last_access,  {:value => Time.now.utc,:expires => (Time.now + 52*7*24*60*60) }
    [status, headers, body]
  end
  
  configure :development do
    #also_reload 'helpers/*.rb'
    #also_reload 'models/*.rb'
    enable :reload_templates
    self.settings.reset!
  end

  helpers do
    def cache_for(time)
      response.headers['Cache-Control'] = "public, max-age=#{time.to_i}"
    end
  end

  get "/" do
    cache_for 10*80
    session[:session_id] = UUIDTools::UUID.timestamp_create.to_s

    response.set_cookie "user_id", {:value => "sss", 
                                    :expires => (Time.now + 52*7*24*60*60)}
    response.headers['X-SSS'] = "SSS"
    response.body = "SSS"
    response.finish
  end

end

