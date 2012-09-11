require ::File.join( ::File.dirname(__FILE__), 'app' )
#puts "running in #{env} mode"

#App.reset! if development?
#Rack::Reloader simply looks at all files that have been required and, if they have changed on disk, re-requires them. So each Sinatra route is re-evaluated when a reload happens.
#However, identical Sinatra routes do NOT override each other. Rather, the first route that is evaluated is used (more precisely, all routes appended to a list and the first matching one is used, so additional identical routes are never run).
#Clearly, Rack::Reloader is not very useful if you can’t change the contents of any route. The solution is to throw away the old routes when the file is reloaded using  Reset!
#This will be done from inside the app 
use Rack::Reloader if development?
run App.new
