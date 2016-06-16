require 'rest-client'
require 'pry'
require 'conserva/exceptions'

module Conserva
  SUCCESS = 'succ'

  class << self
    def initialize(conserva_address, api_key, proxy = nil)
      @@address = conserva_address
      @@api_key = api_key
      RestClient.proxy = proxy
    end

    def create_task(input_file, result_extension)
      input_extension = File.extname(input_file)[1..-1]
      response = RestClient.post "http://#{@@address}/api/v1/task",
                                 input_extension: input_extension,
                                 output_extension: result_extension,
                                 api_key: @@api_key,
                                 file: input_file
      if JSON.parse(response)['id']
        JSON.parse(response)['id']
      else
        raise ServerErrorException
      end

    rescue RestClient::ExceptionWithResponse, RestClient::RequestFailed => exception
      rescue_rest_client_exception exception
    end

    def task_info(task_id)
      response = RestClient.get "http://#{@@address}/api/v1/task/#{task_id}",
                                {params: {api_key: @@api_key}}
      JSON.parse(response)
    rescue RestClient::ExceptionWithResponse, RestClient::RequestFailed => exception
      rescue_rest_client_exception exception
    end

    def task_ready?(task_id)
      task_info(task_id)['state'] == SUCCESS
    end

    def download_file(task_id, name, path)
      info = task_info(task_id)
      File.open("#{path}/#{name}.#{info['output_extension']}", 'w') do |f|
        RestClient.get "http://#{@@address}/api/v1/task/#{task_id}/download",
                       {params: {api_key: @@api_key}} do |str|
          f.write str
        end
      end
    rescue RestClient::ExceptionWithResponse, RestClient::RequestFailed => exception
      rescue_rest_client_exception exception
    end

    def remove_task(task_id)
      RestClient.delete "http://#{@@address}/api/v1/task/#{task_id}",
                        {params: {api_key: @@api_key}}
    rescue RestClient::ExceptionWithResponse, RestClient::RequestFailed => exception
      rescue_rest_client_exception exception
    end

    # return valid combinations as two dimensional array: [[from,to], [from,to], ...]
    def valid_file_convertations
      RestClient.get "http://#{@@address}/api/v1/convert_combinations"
    rescue RestClient::ExceptionWithResponse, RestClient::RequestFailed => exception
      rescue_rest_client_exception exception
    end

    def rescue_rest_client_exception(exception)
      case exception
        when RestClient::UnprocessableEntity
          raise WrongParametersException
        when RestClient::Forbidden
          raise PermissionDeniedException
        when RestClient::ResourceNotFound
          raise WrongResourceException
        when RestClient::NotAcceptable
          raise InvalidRequestException
        when RestClient::InternalServerError
          raise ServerErrorException
        else
          raise exception
      end
    end

    def current_settings
      {conserva_address: @@address,
       proxy: @@proxy,
       api_key: @@api_key}
    end
  end
end
