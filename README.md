# Articulus

This gem is a small library that allows for news-article parsing, simple as that.
The only currently supported backend is the [DiffBot](http://diffbot.com) engine

## Installation

Add this line to your application's Gemfile:

    gem 'articulus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install articulus

## Usage

Usage of Articulus will be slightly different depending on the backend used. Some backends have more or less features.

### DiffBot

    Articulus.backend = :diffbot
    article = Articulus.parse("http://news.somewebsite.com/article.html", :token => "DIFFBOT_TOKEN")
    puts article[:title]
    puts article[:text

DiffBot also provides an option to view their confidence rating on an article. Just set `:stats` to `true` in the `parse` method.

    article = Articulus.parse("http://news.somewebsite.com/article.html", :token => "DIFFBOT_TOKEN", :stats => true)
	confidence = article[:confidence]


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request