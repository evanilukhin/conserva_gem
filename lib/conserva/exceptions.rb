#403 Forbidden
PermissionDeniedException = Class.new(Exception)
#404 Not Found
WrongResourceException = Class.new(Exception)
#406 Not Acceptable
InvalidRequestException = Class.new(Exception)
#422 Unprocessable Entity
WrongParametersException = Class.new(Exception)
#423 Locked
TaskLockedException = Class.new(Exception)
#500 Internal Server Error
ServerErrorException = Class.new(Exception)
