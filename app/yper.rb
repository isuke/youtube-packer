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

  class NotURLError < StandardError; end

  get '/' do
    erb :index
  end

  post '/main' do
    begin
      @url = params[:url]
      raise NotURLError unless @url.url?
      doc = Nokogiri::HTML(open(@url))
      @title = doc.title
      @youtube_ids = youtube_ids doc
      erb :main
    rescue OpenURI::HTTPError, SocketError
      @error_message = 'This value is incorrect url.'
      raise
    rescue NotURLError
      @error_message = 'This value is not url.'
      raise
    end
  end

  error do
    @error_message ||= 'Raised unknown error.'
    erb :index
  end

end
