require 'sinatra'
require 'sinatra/cross_origin'

# cross origin setup
register Sinatra::CrossOrigin
set :allow_origin,  ['http://localhost/', 'http://127.0.0.1', 'http://myapp.com']
set :allow_methods, [:get, :post, :options]

get '/' do
  'This is a logger bridge app. GET /log for details.'
end

get '/log' do
 cross_origin
 'This app accepts GET (with query params) or POST requests to /log from client-side apps. Try it!'
end

options '/log' do
 cross_origin

 # Works around a bug in OPTIONS handling with sinatra/cross-origin
 # Alternative: https://github.com/britg/sinatra-cross_origin/issues/18#issuecomment-115380221
 response.headers["Allow"] = "HEAD, GET, PUT, POST, DELETE, OPTIONS"
 response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

 200
end

post '/log' do
 cross_origin
 request.params.each do |param|
   logger.info(param)
 end

 204
end
