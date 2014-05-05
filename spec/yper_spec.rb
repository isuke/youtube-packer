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
      urls = ['http://www.youtube.com/watch?v=[YOUTUBE_ID]&feature=feedrec_grec_index',
              'http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/[YOUTUBE_ID]',
              'http://www.youtube.com/v/[YOUTUBE_ID]?fs=1&amp;hl=en_US&amp;rel=0',
              'http://www.youtube.com/watch?v=[YOUTUBE_ID]#t=0m10s',
              'http://www.youtube.com/embed/[YOUTUBE_ID]?rel=0',
              'http://www.youtube.com/watch?v=[YOUTUBE_ID]',
              'http://youtu.be/[YOUTUBE_ID]',
              '//www.youtube.com/embed/[YOUTUBE_ID]']
      frame_codes = ['<iframe width="560" height="315" src="[YOUTUBE_URL]" frameborder="0" allowfullscreen></iframe>',
                     '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="425" height="350" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0">' +
                       '<param name="src" value="[YOUTUBE_URL]" />' +
                       '<embed type="application/x-shockwave-flash" width="425" height="350" src="[YOUTUBE_URL]"></embed>' +
                     '</object>']

      body = ''
      frame_codes.each_with_index do |f, i|
        urls.each_with_index do |u, j|
          body += f.gsub(/\[YOUTUBE_URL\]/, u.gsub(/\[YOUTUBE_ID\]/, "id#{format("%04d", i)}#{format("%05d", j)}")) + '\n'
        end
      end
      stub_request(:any, 'http://www.example.com').
        to_return(body: <<-"EOM", status: 200)
          <html>
            <title>Example title</title>
            <body>
              #{body}
            </body>
          </html>
        EOM

      post '/main', url: 'http://www.example.com'
    end

    it "show main" do
      expect(last_response).to be_ok
      expect(last_response.body).to include('<h2>Example title</h2>')
      expect(last_response.body).to include('<p>http://www.example.com</p>')
    end

    it "get youtube ids" do
      expect(last_response.body).to include('id000000000')
      expect(last_response.body).to include('id000000001')
      expect(last_response.body).to include('id000000002')
      expect(last_response.body).to include('id000000003')
      expect(last_response.body).to include('id000000004')
      expect(last_response.body).to include('id000000005')
      expect(last_response.body).to include('id000000006')
      expect(last_response.body).to include('id000100000')
      expect(last_response.body).to include('id000100001')
      expect(last_response.body).to include('id000100002')
      expect(last_response.body).to include('id000100003')
      expect(last_response.body).to include('id000100004')
      expect(last_response.body).to include('id000100005')
      expect(last_response.body).to include('id000100006')
    end
  end
end
