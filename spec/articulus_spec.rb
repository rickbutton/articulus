require 'spec_helper'

describe Articulus do
  
  before :each do
    Articulus.backend = nil
    @fake_backend = double(:backend)
    @fake_backend.stub(:parse).and_return("WOOP")
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