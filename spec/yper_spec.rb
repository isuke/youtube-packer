require 'spec_helper'

describe 'The Youtube Packer' do

  def app
    YPer
  end

  context "when get '/'" do
    it "show index" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Youtube Packer')
    end
  end

  context "when post '/main'" do
    it "show main" do
      post '/main'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Youtube Packer')
    end
  end
end
