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

### Searching

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

### Getting the Article Details

You can get the full article from the ```ArticleRef``` in a number of ways.

You can get the raw xml content using ```ArticleRef.article_content```. For example, the following returns a string:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
str = hits.first.article_content
```

You may also get the parsed xml content using ```ArticleRef.article_xml```. For example, the following returns a ```Nokogiri::XML::Document```:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
xml_doc = hits.first.article_xml
```

Finally you may get an ```Article``` object using ```ArticleRef.article```. For example, the following returns a ```PLOS::Article```:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article = hits.first.article
```

### Working with Articles

Once you have an article, you can get a number of pieces of information from that article. The following will give you an idea of the type of information that's available:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article = hits.first.article

article.article_title # The title of the article
article.article_ids   # Returns a hash of ids. For instance {"doi"=>"##.###/journal.pxxx.###", "publisher-id"=>"###-ABC-###"} 
article.journal_title # The title of the journal that published the article
article.journal_ids   # Returns a hash of ids. Keys could include publisher-id, publisher, allenpress-id, nlm-ta, pmc, etc.
article.issns         # Returns an array of ISSN numbers, keys could include ppub or epub among others.
article.affiliations  # Returns an array of PLOS::Affiliation objects representing the organizations involved in this research.
article.contributors  # Returns an array of PLOS::Contributor objects representing all the people involved in this research, including authors and editors.
article.authors       # Returns an array of PLOS::Name objects, one for each author of this research
article.editors       # Returns an array of PLOS::Name objects, one for each editor of this research
article.figures       # Returns an array of PLOS::Figure objects representing the figures in this article.
article.references    # Returns an array of PLOS::Reference objects representing all the articles this article references.
article.sections      # Returns an array of PLOS::Section objects containing the actual content of the article.
article.named_content # Returns an array of Hashs objects. Each representing a piece of "named-content". Named content is often used to separate genes from other text.
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
