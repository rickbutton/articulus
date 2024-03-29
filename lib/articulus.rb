require "articulus/version"
require "articulus/backend/diffbot"
require 'simple-rss'
require 'open-uri'
module Articulus
  
  class InvalidApiKeyError < StandardError; end
  class InvalidBackendError < StandardError; end
  
  @@backend = nil

  def self.backend=(backend)
    @@backend = backend
  end
  
  def self.get_articles(feed)
    articles = []
    tries = 3
    begin
      rss = SimpleRSS.parse open(feed)
    rescue Exception => e
      tries -= 1
      retry if tries > 0
      return []
    end
    articles = rss.entries.map do |entry|
      { :title => entry.title,
                    :url => entry.link,
                    :date => entry.pubDate || DateTime.now,
                    :uid => entry.guid || entry.link,
                    :author => entry.author}
    end
    articles
  end
  
  def self.parse(url, options = {})
    check_backend
    
    get_backend_module.parse(url, options)
  end
  
  private
  
    def self.get_backend_module
      case @@backend
      when :diffbot
        Articulus::Backend::DiffBot
      end
    end
    
    def self.check_backend
      raise InvalidBackendError, "#{@@backend} is not a valid backend" unless get_backend_module
    end
end