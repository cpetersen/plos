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

Basic

```ruby
require 'plos'

client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
hits.each do |hit|
  puts "#{hit.score} - #{hit.title} - #{hit.article_url}"
end

xml = hits[2].article_xml
puts hits[2].citation
```

Change the number of results starting position. The following retrieves 50 results starting at result 100:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft", 50, 100)
```

Retrieve all results (paged). The following retrieves all results 200 - 300:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.all(100, 200)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
