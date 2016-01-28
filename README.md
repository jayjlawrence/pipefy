# Pipefy


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pipefy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pipefy

## Usage

For local development, build/install local copy of the gem
````
gem build pipefy.gemspec
gem install ./pipefy-0.1.0.gem
````

Then you can experiment with the gem via pry console.

For example to create a card on the Scorecard pipe: 

````ruby
require 'Pipefy'
connection = Pipefy::Connection.new
connection.create_card "Scorecard", "Demo Card", {"URL" => "https://test.com/123"}

````
Oh wait better idea you can skip rebuilding gem and just use bundler

````sh
bundle console
````
