require 'rubygems'
require 'sinatra'
require 'haml'
require './hasher'

get '/' do
  haml :index
end

post '/' do
  token = params[:token] || "deadbeef"
  @results = HashMaker.hash_it(token)
  haml :result
end
