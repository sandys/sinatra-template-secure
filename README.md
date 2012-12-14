* Install jruby using rvm
* install your gems using ```rvm jruby-1.6.7 do  jruby "--1.9" -S bundle install```
* for commandline inspection run ```rvm jruby-1.6.7 do  jruby "--1.9" -S bundle exec pry ```
* to run your app for debugging run ```rvm jruby-1.6.7 do  jruby "--1.9" -S bundle exec rackup -E development ```
   * remember this app will reload most files for you on change, so you dont have to restart your server. Except, of course, ```lib```
* bundle exec thin start -R config.ru
* bundle exec unicorn -c unicorn.rb -E development -l 0.0.0.0:3001
