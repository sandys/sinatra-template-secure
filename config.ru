#require 'rack/protection'
#use Rack::Protection, :except => :xss_header
#use Rack::Protection::AuthenticityToken
require 'bundler'
Bundler.require

require 'sinatra'
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

App.set :time_at_startup, Time.now
App.set :session_key, "sss" 
#set :session_key, "sss" 
App.set :session_secret, "fflgjfljglfkjglfjg" 
#set :session_secret, "fflgjfljglfkjglfjg" 

=begin
  myapp = App.new
  sessioned = Rack::Session::Pool.new(myapp,
      :key => "sss",
      :secret => "dfjd;fj;dfj;df;ldfl;df;",
      :expire_after => 2592000
    )
  run sessioned
=end

#prot = Rack::Protection.new(sessioned,{:except => [:xss_header]})
#run sessioned 

b = Rack::Builder.new do
   use  ::Rack::Session::Pool, :key => "sss", :secret => "dfkjdlfjldjfldjkkn909", :expire_after => 2592000
   #use ::Rack::Protection::AuthenticityToken
   use ::Rack::MethodOverride

  run App
end.to_app

#run App 
run b
