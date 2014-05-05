require 'sinatra/base'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'

class YPer < Sinatra::Base
  set :public_folder, File.expand_path(File.join(root, '..', 'public'))

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  post '/main' do
    @url = params[:url]
    doc = Nokogiri::HTML(open(@url))
    @title = doc.title
    @youtube_ids = youtube_ids doc
    erb :main
  end

  def youtube_ids(doc)
    result = []
    doc.css('object > param').each do |d|
      d['value'].scan(/^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/) do |id|
        result << id[6] unless result.include?(id[6])
      end
    end
    doc.css('iframe').each do |d|
      d['src'].scan(/^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/) do |id|
        result << id[6] unless result.include?(id[6])
      end
    end
    result
  end
end
