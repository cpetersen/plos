# PLoS [![Build Status](https://travis-ci.org/cpetersen/plos.png?branch=master)](https://travis-ci.org/cpetersen/plos) [![Coverage Status](https://coveralls.io/repos/cpetersen/plos/badge.png?branch=master)](https://coveralls.io/r/cpetersen/plos?branch=master)

A Ruby library for interacting with the Public Library of Science (PLoS) API

## Installation

Add this line to your application's Gemfile:

    gem 'plos'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plos

## Usage

### Retrieving All Article References

The ```all``` methods returns all references from PLOS. The method takes the form ```PLOS::Client.all(start, rows)```. You can page the results using the start parameter. Rows determines the page size.

```ruby
require 'plos'

client = PLOS::Client.new(ENV["API_KEY"])
hits = client.all
```

### Searching

You can perform a basic search using the ```PLOS::Client.search(query, start, rows)``` method. The second two parameters are optional. That method returns a ```PLOS::ArticleSet``` object. ```ArticleSet``` inherits from Array and includes some meta-information about the search. The following example show the information that's available:

```ruby
require 'plos'

client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")

hits.status # Return status of the query (0 is success)
hits.time # The amount of time the query took (in ms)
hits.num_found # Total number of results
hits.max_score # Score of the closest matching document
hits.start # Index of the first result

hits.each do |hit|
  puts "#{hit.score} - #{hit.title} - #{hit.id}"
end
```

Change the number of results starting position. The following retrieves 50 results starting at result 100:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft", 100, 50)
```

Retrieve all results (paged). The following retrieves all results 200 - 300:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.all(200, 100)
```

Note: there may be multiple ```ArticleRef```'s pointing to the same article. For instance, a search for "*:*" will return references for:

 * 10.1371/journal.pbio.0040394
 * 10.1371/journal.pbio.0040394/title
 * 10.1371/journal.pbio.0040394/abstract
 * 10.1371/journal.pbio.0040394/references
 * 10.1371/journal.pbio.0040394/body

which all point to the same article, 10.1371/journal.pbio.0040394. You can access the id of the article and identifier which part of the article this reference refers to with the methods ```article_id``` and ```article_part``` respectively.

```ruby
require 'plos'

client = PLOS::Client.new(ENV["API_KEY"])
hits = client.all

hits.each do |hit|
  puts "#{hit.title} - #{hit.article_id} - #{hit.article_part}"
end
```

### Getting the Article Details

You may get an ```Article``` object using ```ArticleRef.article```. For example, the following returns a ```PLOS::Article```:


```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article = hits.first.article
```

### Getting the Article's Citation

You may get a citation for the article using the ```citation``` method.

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
citation = hits.first.citation # returns the RIS citation for the first ArticleRef
```

You may also get the citation from the ```Article``` object. The following code get the citation. Both ```Article```'s and ```ArticleRef```'s can return BibTex and RIS citations.

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article = hits.first.article
citation = article.citation("bibtex") # returns the BibTex citation for the Article
```

### Working with Articles

Once you have an article, you can get a number of pieces of information from that article. The following will give you an idea of the type of information that's available:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article = hits.first.article

article.article_title # The title of the article
article.article_ids   # Returns a Hash of ids. For instance {"doi"=>"##.###/journal.pxxx.###", "publisher-id"=>"###-ABC-###"} 
article.journal_title # The title of the journal that published the article
article.journal_ids   # Returns a Hash of ids. Keys could include publisher-id, publisher, allenpress-id, nlm-ta, pmc, etc.
article.issns         # Returns a Hash of ISSN numbers, keys could include ppub or epub among others.
article.affiliations  # Returns an Array of PLOS::Affiliation objects representing the organizations involved in this research.
article.contributors  # Returns an Array of PLOS::Contributor objects representing all the people involved in this research, including authors and editors.
article.authors       # Returns an Array of PLOS::Name objects, one for each author of this research
article.editors       # Returns an Array of PLOS::Name objects, one for each editor of this research
article.figures       # Returns an Array of PLOS::Figure objects representing the figures in this article.
article.references    # Returns an Array of PLOS::Reference objects representing all the articles this article references.
article.sections      # Returns an Array of PLOS::Section objects containing the actual content of the article.
article.named_content # Returns an Array of Hash objects. Each representing a piece of "named-content". Named content is often used to separate genes from other text.
```

### Other Helper Methods

If you have the id of an ```Article```, you can get the content in various ways. You can get the raw content:

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article_id = hits.first.id
PLOS::Article.content(article_id) # Returns the xml as a string
```

```PLOS::Article.xml(id)``` returns a ```Nokogiri::XML``` object of the xml contents.

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article_id = hits.first.id
PLOS::Article.xml(article_id) # Returns the xml
```

```PLOS::Article.get(id)``` returns a ```PLOS::Article``` object.

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article_id = hits.first.id
PLOS::Article.get(article_id) # Returns the Article object
```

```PLOS::Article.citation(id)``` returns a ```PLOS::Article``` object.

```ruby
require 'plos'
client = PLOS::Client.new(ENV["API_KEY"])
hits = client.search("xenograft")
article_id = hits.first.id
PLOS::Article.citation(article_id) # Returns the RIS citation as a String (could pass "BibTex" as the second parameter to get the BibTex format)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
