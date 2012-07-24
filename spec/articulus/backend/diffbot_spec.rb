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
    
    it 'should be able to handle really ugly urls (with params)' do
      VCR.use_cassette("diffbot_ugly_url_request") do
        ugly_url = "http://usnews.msnbc.msn.com/_news/2012/07/20/12850048-cops-weeks-of-planning-went-into-shootings-at-colo-batman-screening?lite&amp;__utma=14933801.651844641.1342504752.1342850416.1342852536.5&amp;__utmb=14933801.5.10.1342852536&amp;__utmc=14933801&amp;__utmx=-&amp;__utmz=14933801.1342852536.5.2.utmcsr=google|utmccn=%28organic%29|utmcmd=organic|utmctr=nbc%20news.com&amp;__utmv=14933801.|8=Earned%20By=msnbc|cover=1^12=Landing%20Content=Mixed=1^13=Landing%20Hostname=www.nbcnews.com=1^30=Visit%20Type%20to%20Content=Earned%20to%20Mixed=1&amp;__utmk=152072633"
        expect { Articulus::Backend::DiffBot.parse(ugly_url, :token => "fake_working_token") }.to_not raise_error
      end
    end
  end

end