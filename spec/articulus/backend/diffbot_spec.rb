require 'spec_helper'

describe Articulus::Backend::DiffBot do

  describe '.parse' do
    
    before :each do
      @url = "http://abcnews.go.com/Entertainment/slideshow/celebrities-twitter-kardashian-kanye-6584329"
    end
    
    it 'should throw an InvalidApiKeyError when not given a developer token' do
      expect { Articulus::Backend::DiffBot.parse(@url, :token => nil) }.to raise_error Articulus::InvalidApiKeyError
      expect { Articulus::Backend::DiffBot.parse(@url) }.to raise_error Articulus::InvalidApiKeyError
    end
    it 'should throw an InvalidApiKeyError when not given an authorized developer token' do
      VCR.use_cassette("diffbot_invalid_request") do
        expect { Articulus::Backend::DiffBot.parse(@url, :token => "not_a_real_token") }.to raise_error Articulus::InvalidApiKeyError
      end
    end
    it 'should return the confidence when the stats option is included' do
      VCR.use_cassette("diffbot_valid_request_with_stats") do
        Articulus::Backend::DiffBot.parse(@url, :token => "fake_working_token", :stats=> true)[:confidence].should_not eq nil
      end
    end
    it 'should replace negative infinity with 0 for the confidence value' do
      VCR.use_cassette("diffbot_valid_request_with_stats_negative_infinity") do
        Articulus::Backend::DiffBot.parse(@url, :token => "fake_working_token", :stats=> true)[:confidence].should eq 0
      end
    end
    
    it 'should include all of the required fields' do
      VCR.use_cassette("diffbot_valid_request") do
        article = Articulus::Backend::DiffBot.parse(@url, :token => "fake_working_token")
        %w(title url author text date).each do |f|
          article[f.to_sym].should_not be_nil
        end 
      end
    end
  end

end