require 'rubygems'
require 'spork'
require 'vcr' 
unless ENV['DRB']
  require 'simplecov'
  SimpleCov.start do 
    add_filter '/spec'
  end
end
require 'rspec/autorun'
require 'articulus'

def config
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    c.hook_into :webmock # or :fakeweb
    c.ignore_localhost = true
  end
  
  

  RSpec.configure do |config|
    # some (optional) config here
  end
end

Spork.prefork do
  config
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start
  end
end