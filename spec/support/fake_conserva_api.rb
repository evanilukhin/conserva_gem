require 'sinatra/base'
require 'sinatra/namespace'
class FakeConservaAPI < Sinatra::Base
  register Sinatra::Namespace

  namespace '/api' do
    namespace '/v1' do
      get '/task/:id' do
        case params[:id]
          when '1'
            status 200
            {'source_file': '1464164329156_input.txt',
             'converted_file': '1464164329156_input.txt',
             'input_extension': 'txt',
             'output_extension': 'txt',
             'state': 'succ',
             'created_at': '2016-05-25 11:18:49 +0300',
             'updated_at': '2016-05-25 11:18:50 +0300',
             'finished_at': '2016-05-25 11:18:50 +0300',
             'source_file_sha256': '5cd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea25',
             'result_file_sha256': '5cd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea25'}.to_json
          when '2'
            status 403
          when '3'
            status 500
          when '4'
            status 200
            {'result_file_sha256': 'efd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea15'}.to_json
          else
            status 404
        end
      end

      post '/task' do
        case params[:output_extension]
          when 'pdf'
            halt 406
          when 'tmp'
            halt 422
          else
            {id: 1}.to_json
        end
      end

      get '/task/:id/download' do
        case params[:id]
          when '1', '4' # finished task
            send_file "#{File.dirname(__FILE__)}/../files/input.txt", filename: 'result.txt'
          when '2'
            status 202
          else
            status 404
        end
      end

      delete '/task/:id' do
        case params[:id]
          when '1'
            status 200
          else
            status 423
        end
      end

      get '/convert_combinations' do
        content_type :json
        status 200
        [%w(txt txt), %w(doc pdf)].to_json
      end
    end
  end

end