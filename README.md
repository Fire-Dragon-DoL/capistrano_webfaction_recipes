# CapistranoWebfactionRecipes

This is a simple gem that provides some useful capistrano recipes to handle a Webfaction shared hosting.

["View the capistrano_webfaction_recipes documentation"](http://omniref.com/ruby/gems/capistrano_webfaction_recipes )

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano_webfaction_recipes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano_webfaction_recipes

## Usage

Require the gem files in your deploy.rb file:

    require 'capistrano_webfaction_recipes/all'

Or (better) create a deploy.rb file through the generator by running:

    rails generate webfaction:install

Fill the options interactively, this will generate a nice deploy.rb file, ready to be used.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
