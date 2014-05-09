Testing for rails issue  
----------------

See tails at https://github.com/rails/rails/issues/10039#issuecomment-42513003



Steps to follow: 

* Run the app in sub-folder
* Run the sidekiq in sub-folder using `bundle exec sidekiq`
* Run the mail server script using  `cd scripts && bundle exec ruby smtp_server.rb`
* Visit http://localhost:3000/notification/index
* Send some notification to sidekiq
* See the logs of smtp server and sidekiq
