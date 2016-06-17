require 'sinatra/base'
require 'sinatra/namespace'
class FakeConservaAPI < Sinatra::Base
  register Sinatra::Namespace

  namespace '/api' do
    namespace '/v1' do
      get '/task/:id' do
        if params[:id] == '1'
          status 200
          {id: 1}.to_json
        else
          status 404
        end
      end

      post '/task' do
      end

      get '/task/:id/download' do
        case params[:id]
          when '1' # finished task
            send_file '../files/result.pdf', filename: 'result.pdf'
          when '2'
            status 202
          else
            status 404
        end
      end

      delete '/task/:id' do
      end

      get '/convert_combinations' do
        content_type :json
        status 200
        [%w(txt pdf), %w(doc pdf)].to_json
      end
    end
  end

end