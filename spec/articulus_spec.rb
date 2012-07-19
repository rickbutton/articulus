require 'spec_helper'

describe Articulus do
  
  before :each do
    Articulus.backend = nil
    @fake_backend = double(:backend)
    @fake_backend.stub(:parse).and_return("WOOP")
    
    @feed_url = "http://rss.cnn.com/rss/cnn_us.rss"
  end
  
  describe '.parse' do
    it 'should throw an InvalidBackendError when no backend is specified' do
      expect {  Articulus.parse("http://google.com", {}) }.to raise_error Articulus::InvalidBackendError
    end
    it 'should throw an InvalidBackendError when an invalid backend is specified' do
      Articulus.backend = :lol_not_a_backend
      expect {  Articulus.parse("http://google.com", {}) }.to raise_error Articulus::InvalidBackendError
    end
    it 'should return the backend\'s parsed result' do
      Articulus.stub(:get_backend_module).and_return(@fake_backend)
      Articulus.parse("http://google.com").should eq "WOOP"
    end
  end
  
  describe '.get_articles' do
    it 'should return the proper list of articles when given a valid link' do
      VCR.use_cassette("get_articles_valid_request") do
        # 30 because thats how many are in the fixture at the time of recording
        Articulus.get_articles(@feed_url).count.should eq 30
      end
    end
    it 'should return an empty array when it the link cannot be parsed' do
      VCR.use_cassette("get_articles_invalid_request") do
        # 30 because thats how many are in the fixture at the time of recording
        Articulus.get_articles("lol not a url").count.should eq 0
      end
    end
    it 'should return an array of articles that all have the required fields' do 
      VCR.use_cassette("get_articles_valid_request") do
        articles = Articulus.get_articles(@feed_url)
        %w(title url date uid).each do |f|
          articles.each do |article|
            article[f.to_sym].should_not be_nil
          end
        end
      end
    end
  end
  
  describe '.get_backend_module' do
    it 'should assign the correct backend to the correct symbol' do
      {
        :diffbot => Articulus::Backend::DiffBot
      }.each do |sym, mod|
        #hack to test private method
        Articulus.backend = sym
        Articulus.send(:get_backend_module).should eq mod
      end
    end
  end
  
end