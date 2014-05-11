require 'sinatra/base'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'

require_relative 'helpers'

class YPer < Sinatra::Base
  set :public_folder, File.expand_path(File.join(root, '..', 'public'))
  set :raise_errors, false
  disable :show_exceptions

  helpers Sinatra::YPer::Helpers

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

  error do
    @url = params[:url]
    @error_message = env['sinatra.error'].message
    erb :index
  end

end
