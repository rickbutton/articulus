require 'net/http'
require 'json'
module Articulus
module Backend
module DiffBot
  
  def self.parse(url, options = {})
    check_token(options)
    uri = URI.parse(request_url_from_article(url, options))
    response = Net::HTTP.get_response(uri)
    
    case response
    when Net::HTTPSuccess
      json = JSON.parse(response.body)
      return {
        :title => json["title"],
        :url => url,
        :author => json["author"],
        :text => json["text"],
        :date => json["date"]
      }
    when Net::HTTPUnauthorized || Net::HTTPForbidden
      raise InvalidApiKeyError, "Developer token is unauthorized/forbidden"
    end
  end
  
  private
  
    def self.request_url_from_article(url, options)
      check_token(options)
      html_option = options[:html] ? "&html=yes" : ""
      token = "token=#{options[:token]}"
      "http://www.diffbot.com/api/article?#{token}&url=#{url}#{html_option}"
    end
    
    def self.check_token(options)
      raise InvalidApiKeyError, "The DiffBot API Key must be included in the options hash ( use :token)." unless options[:token]
    end
  
end
end
end