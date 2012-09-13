require 'bundler'
Bundler.require

require 'rack'
require 'rack/session/pool'

require ::File.join( ::File.dirname(__FILE__), 'app' )
lib_path = File.expand_path('../lib', __FILE__)
$:.unshift(lib_path) unless $:.include?(lib_path)
$:.unshift('.') 
#puts "running in #{env} mode"

#App.reset! if development?
#Rack::Reloader simply looks at all files that have been required and, if they have changed on disk, re-requires them. So each Sinatra route is re-evaluated when a reload happens.
#However, identical Sinatra routes do NOT override each other. Rather, the first route that is evaluated is used (more precisely, all routes appended to a list and the first matching one is used, so additional identical routes are never run).
#Clearly, Rack::Reloader is not very useful if you can’t change the contents of any route. The solution is to throw away the old routes when the file is reloaded using  Reset!
#This will be done from inside the app 
use Rack::Reloader 


incrementor = lambda do |env|
    Rack::Response.new(env["rack.session"].inspect).to_a
    puts "in incrementor"
end

#these variables are not available in "settings" in the modular app
App.set :time_at_startup, Time.now
App.set :session_key, "sss" 
App.set :session_secret, "fflgjfljglfkjglfjg" 

#this works, but this is moot with the below method
=begin
  myapp = App.new
  sessioned = Rack::Session::Pool.new(myapp,
      :key => "sss",
      :secret => "dfjd;fj;dfj;df;ldfl;df;",
      :expire_after => 2592000
    )
  run sessioned
=end

# a lot of this I figure out from rack-protection/lib/rack/protection.rb
builder = Rack::Builder.new do
   use ::Rack::Session::Pool, :key => "sss", :secret => "dfkjdlfjldjfldjkkn909", :expire_after => 2592000
   use ::Rack::Protection::AuthenticityToken
   use ::Rack::MethodOverride
  run App
end.to_app

run builder
