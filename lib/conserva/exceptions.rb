module Conserva
  # base class for conserva exceptions
  ConvertError = Class.new(StandardError)

  # Check data
  ClientError = Class.new(ConvertError)
  # Try later
  ServerError = Class.new(ConvertError)

  # RestClient Exceptions
  #403 Forbidden
  PermissionDenied = Class.new(ClientError)
  #404 Not Found
  WrongResource = Class.new(ClientError)
  #406 Not Acceptable
  InvalidRequest = Class.new(ClientError)
  #422 Unprocessable Entity
  WrongParameters = Class.new(ClientError)
  #423 Locked
  TaskLocked = Class.new(ServerError)
  #500 Internal Server Error
  InternalServerError = Class.new(ServerError)
  # File was not correct download
  DownloadError = Class.new(ServerError)
end
