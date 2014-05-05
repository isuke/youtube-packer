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
    erb :main
  end
end
