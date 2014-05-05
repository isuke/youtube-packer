require 'sinatra/base'
require 'sinatra/reloader'

class YPer < Sinatra::Base
  set :public_folder, File.expand_path(File.join(root, '..', 'public'))

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  post '/main' do
    erb :main
  end
end
