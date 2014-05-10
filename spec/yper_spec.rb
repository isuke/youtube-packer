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

    def get_code(frame_codes, urls)
      body = ''
      frame_codes.each_with_index do |f, i|
        urls.each_with_index do |u, j|
          body += f.gsub(/\[YOUTUBE_URL\]/, u.gsub(/\[YOUTUBE_ID\]/, "id#{format("%04d", i)}#{format("%05d", j)}")) + '\n'
        end
      end
      body
    end

    before do
      frame_codes = ['<iframe width="560" height="315" src="[YOUTUBE_URL]" frameborder="0" allowfullscreen></iframe>',
                     '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="425" height="350" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0">' +
                       '<param name="src" value="[YOUTUBE_URL]" />' +
                       '<embed type="application/x-shockwave-flash" width="425" height="350" src="[YOUTUBE_URL]"></embed>' +
                     '</object>']
      urls = ['http://www.youtube.com/watch?v=[YOUTUBE_ID]&feature=feedrec_grec_index',
              'http://www.youtube.com/v/[YOUTUBE_ID]?fs=1&amp;hl=en_US&amp;rel=0',
              'http://www.youtube.com/watch?v=[YOUTUBE_ID]#t=0m10s',
              'http://www.youtube.com/embed/[YOUTUBE_ID]?rel=0',
              'http://youtu.be/[YOUTUBE_ID]',
              '//www.youtube.com/embed/[YOUTUBE_ID]']

      body = get_code(frame_codes, urls)
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
      expect(last_response.body).to include('<h2><a href=http://www.example.com>Example title</a></h2>')
    end

    it "get youtube ids" do
      expect(last_response.body).to include("var VIDEO_ID = 'id000000000';")
      expect(last_response.body).to include("var list = 'id000000001," +
                                                        "id000000002," +
                                                        "id000000003," +
                                                        "id000000004," +
                                                        "id000000005," +
                                                        "id000100000," +
                                                        "id000100001," +
                                                        "id000100002," +
                                                        "id000100003," +
                                                        "id000100004," +
                                                        "id000100005")
    end
  end
end
