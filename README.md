# UnicornService

Capistrano plugin that provide opportunity to create unicorn service. It gives capistrano task for create script in
/etc/init.d/ for unicorn's deamon and update rc.d for auto start up unicorn application after reboot system


## Usage
### Setup

Add the library to your Gemfile:

    group :development do
      gem 'unicorn_service', :require => false
    end

And load it into your deployment script config/deploy.rb:

    require 'unicorn_service'

Set constants:

    set :application, 'your_application'
    set :user, 'your_user'
    set :deploy_to, '/path/to/app'

### What's different in this fork

I've added DEPLOY_ENV which is either staging or production to accommodate multiple stages.

###Run

To create deamon run:

    bundle exec cap unicorn_service:create_script

(Be sure Capistrano is set to run using pty not tty.)

To install init script run:

    bundle exec cap unicorn_service:update_rc

To do it all at once:

    bundle exec cap unicorn_service:start

## Contributing

1. Fork it ( http://github.com/<my-github-username>/unicorn_service/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
