module Conserva
  # base class for conserva exceptions
  ConvertError = Class.new(StandardError)

  # RestClient Exceptions
  #403 Forbidden
  PermissionDenied = Class.new(ConvertError)
  #404 Not Found
  WrongResource = Class.new(ConvertError)
  #406 Not Acceptable
  InvalidRequest = Class.new(ConvertError)
  #422 Unprocessable Entity
  WrongParameters = Class.new(ConvertError)
  #423 Locked
  TaskLocked = Class.new(ConvertError)
  #500 Internal Server Error
  ServerError = Class.new(ConvertError)
  # File was not correct download
  DownloadError = Class.new(ConvertError)
end
