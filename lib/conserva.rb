require 'rest-client'
require 'conserva/exceptions'
require 'backports'
require 'pry'
require 'net/ping/http'
module Conserva
  FINISHED = 'finished'

  class << self
    def initialize(conserva_address, api_key, options = {})
      @@address = conserva_address
      @@api_key = api_key
      default_options = {proxy: nil}
      options.reverse_merge! default_options
      RestClient.proxy = options[:proxy]
    end

    def create_task(input_file, input_extension, result_extension)
      response = RestClient.post "http://#{@@address}/api/v1/task",
                                 input_extension: input_extension,
                                 output_extension: result_extension,
                                 api_key: @@api_key,
                                 file: input_file
      JSON.parse(response)['id'] || (raise ServerErrorException)

    rescue RestClient::ExceptionWithResponse, RestClient::RequestFailed => exception
      rescue_rest_client_exception exception
    end

    def task_info(task_id)
      response = RestClient.get "http://#{@@address}/api/v1/task/#{task_id}",
                                {params: {api_key: @@api_key}}
      JSON.parse(response).symbolize_keys
    rescue RestClient::ExceptionWithResponse, RestClient::RequestFailed => exception
      rescue_rest_client_exception exception
    end

    def task_ready?(task_id)
      task_info(task_id)[:state] == FINISHED
    end

    def download_file(task_id, options = {})
      default_options = {check_sum: true}
      options.reverse_merge! default_options

      downloaded_file = RestClient.get "http://#{@@address}/api/v1/task/#{task_id}/download",
                                             {params: {api_key: @@api_key}}
      raise DownloadError if options[:check_sum] && (Digest::SHA256.hexdigest(downloaded_file) != task_info(task_id)[:result_file_sha256])
      downloaded_file
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
      result_string = RestClient.get "http://#{@@address}/api/v1/convert_combinations"
      JSON.parse(result_string)
    rescue RestClient::ExceptionWithResponse, RestClient::RequestFailed => exception
      rescue_rest_client_exception exception
    end

    def current_settings
      {conserva_address: @@address,
       proxy: (defined? @@proxy) ? @@proxy : 'no proxy',
       api_key: @@api_key}
    end

    def alive?
      ping_conserva = Net::Ping::HTTP.new("http://#{@@address}/api/v1/convert_combinations")
      ping_conserva.ping?
    end

    def rescue_rest_client_exception(exception)
      case exception
        when RestClient::UnprocessableEntity
          raise WrongParameters
        when RestClient::Forbidden
          raise PermissionDenied
        when RestClient::ResourceNotFound
          raise WrongResource
        when RestClient::NotAcceptable
          raise InvalidRequest
        when RestClient::InternalServerError
          raise InternalServerError
        when RestClient::Locked
          raise TaskLocked
        else
          raise exception
      end
    end
  end
end
