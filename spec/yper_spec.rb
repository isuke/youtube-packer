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
    before do
      stub_request(:any, 'http://www.example.com').
        to_return(body: <<-"EOM", status: 200)
          <html>
            <title>Example title</title>
            <body>Example body</body>
          </html>
        EOM
    end

    it "show main" do
      post '/main', url: 'http://www.example.com'
      expect(last_response).to be_ok
      expect(last_response.body).to include('<h2>Example title</h2>')
      expect(last_response.body).to include('<p>http://www.example.com</p>')
    end
  end
end
