require 'rubygems'
require 'sinatra'
require 'uuidtools'
require 'rack/session/pool'
#require 'rack/protection'
#require 'rack/protection/authenticity_token'
require 'securerandom'
require 'slim'

=begin
%w(models controllers concerns).each do |name|
   Dir[File.join('app', name, '**/*.rb')].each do |file|
     require_relative file
   end
 end
=end


class SSSAuthenticityToken < Rack::Protection::AuthenticityToken
  def accepts?(env)
    return true if safe?(env)
    super(env)
  end
end

class App < Sinatra::Base

  configure do
      enable :logging
      set :protection, :except => [:authenticity_token, :form_token, :json_csrf, :remote_referrer, :form_token, :escaped_params, :frame_options, :path_traversal, :session_hijacking, :ip_spoofing]
  end

  def call(env)
    #global logging
    puts "startup = #{settings.time_at_startup} vs #{Time.now}"
    puts 'manager: ' + env['REQUEST_METHOD'] + ' ' + env['REQUEST_URI'] + " session_key = #{settings.session_key}"
    #super calls the "get", "post", etc. functions
    status, headers, body = super

    headers['X-Middleware'] = 'true'
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

    # to get your cookies do ```curl -c cookies.txt -i -L http://localhost:9292 ```
    # to send your cookie do ```curl -b cookies.txt -i -L http://localhost:9292 ```
    def csrf_token
      session[:csrf] ||= SecureRandom.hex 32
    end
  end

  post "/submit/" do
    response.body = "success"
    response.finish
  end

  get "/" do
    cache_for 10*80
    #session[:session_id] = UUIDTools::UUID.timestamp_create.to_s
    

    response.set_cookie "user_id", {:value => "sss", 
                                    :expires => (Time.now + 52*7*24*60*60)}
    response.headers['X-SSS'] = "SSS"
    #response.body = "SSS"
    puts "session = #{@pool.inspect} oor #{session.inspect} and #{session.to_hash.inspect} key =#{session[:session_id]}"
    slim :index
    # response.finish only if you are not using a template rendering call above
  end

end

