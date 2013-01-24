# PLoS [![Build Status](https://travis-ci.org/cpetersen/plos.png?branch=master)](https://travis-ci.org/cpetersen/plos)

A Ruby library for interacting with the Public Library of Science (PLoS) API

## Installation

Add this line to your application's Gemfile:

    gem 'plos'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plos

## Usage

```ruby
require 'plos'

client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
hits.each do |hits|
  puts "#{hit.score} - #{hit.title}"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
