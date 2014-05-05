require 'spec_helper'

describe 'The Youtube Packer' do

  def app
    App
  end

  context "when get '/'" do
    it "show index" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Youtube Packer')
    end
  end
end
