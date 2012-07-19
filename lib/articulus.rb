require "articulus/version"
require "articulus/backend/diffbot"
module Articulus
  
  class InvalidApiKeyError < StandardError; end
  class InvalidBackendError < StandardError; end
  
  @@backend = nil

  def self.backend=(backend)
    @@backend = backend
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