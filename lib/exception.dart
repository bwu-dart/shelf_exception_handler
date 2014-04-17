library shelf_exception_response.exception;
import "dart:io" show HttpStatus;

/**
 * HTTP exception enables to immediately stop request execution
 * and send an appropriate error message to the client. An option
 * [Map] data can be provided to add additional information as
 * the response body.
 */
class HttpException implements Exception {

  final int status;
  final String message;
  final Map<String, dynamic> data;

  const HttpException([this.status = HttpStatus.INTERNAL_SERVER_ERROR, this.message = "Internal Server Error", this.data]);

  Map<String, dynamic> toMap() {
    Map<String, dynamic>result = {
        "status": status,
        "message": message
    };
    if(data != null && !data.isEmpty) {
      data.forEach((name, value) {
        result[name] = value;
      });
    }
    return result;
  }

  String toString() {
    return "Status ${status.toString()}: ${message}";
  }

}

// 400 Bad Request
class BadRequestException extends HttpException {
  final int status = HttpStatus.BAD_REQUEST;
  final String message = "Bad Request";
  final Map<String, dynamic> data;
  const BadRequestException([this.data]);
}

// 401 Unauthorized
class UnauthorizedException extends HttpException {
  final int status = HttpStatus.UNAUTHORIZED;
  final String message = "Unauthorized";
  final Map<String, dynamic> data;
  const UnauthorizedException([this.data]);
}

// 402 Payment Required
class PaymentRequiredException extends HttpException {
  final int status = HttpStatus.PAYMENT_REQUIRED;
  final String message = "Payment Required";
  final Map<String, dynamic> data;
  const PaymentRequiredException([this.data]);
}

// 403 Forbidden
class ForbiddenException extends HttpException {
  final int status = HttpStatus.FORBIDDEN;
  final String message = "Forbidden";
  final Map<String, dynamic> data;
  const ForbiddenException([this.data]);
}

// 404 Not Found
class NotFoundException extends HttpException {
  final int status = HttpStatus.NOT_FOUND;
  final String message = "Not Found";
  final Map<String, dynamic> data;
  const NotFoundException([this.data]);
}

// 405 Method Not Allowed
class MethodNotAllowed extends HttpException {
  final int status = HttpStatus.METHOD_NOT_ALLOWED;
  final String message = "Method Not Allowed";
  final Map<String, dynamic> data;
  const MethodNotAllowed([this.data]);
}

// 406 Not Acceptable
class NotAcceptableException extends HttpException {
  final int status = HttpStatus.NOT_ACCEPTABLE;
  final String message = "Not Acceptable";
  final Map<String, dynamic> data;
  const NotAcceptableException([this.data]);
}

// 409 Conflict
class ConflictException extends HttpException {
  final int status = HttpStatus.CONFLICT;
  final String message = "Conflict";
  final Map<String, dynamic> data;
  const ConflictException([this.data]);
}

// 410 Gone
class GoneException extends HttpException {
  final int status = HttpStatus.GONE;
  final String message = "Gone";
  final Map<String, dynamic> data;
  const GoneException([this.data]);
}

// 412 Precondition Failed
class PreconditionFailedException extends HttpException {
  final int status = HttpStatus.PRECONDITION_FAILED;
  final String message = "Precondition Failed";
  final Map<String, dynamic> data;
  const PreconditionFailedException([this.data]);
}

// 415 Unsupported Media Type
class UnsupportedMediaTypeException extends HttpException {
  final int status = HttpStatus.UNSUPPORTED_MEDIA_TYPE;
  final String message = "Unsupported Media Type";
  final Map<String, dynamic> data;
  const UnsupportedMediaTypeException([this.data]);
}

// 429 Too Many Requests
class TooManyRequestsException extends HttpException {
  final int status = 429;
  final String message = "Too Many Requests";
  final Map<String, dynamic> data;
  const TooManyRequestsException([this.data]);
}

// 501 Not Implemented
class NotimplementedException extends HttpException {
  final int status = HttpStatus.NOT_IMPLEMENTED;
  final String message = "Not Implemented";
  final Map<String, dynamic> data;
  const NotimplementedException([this.data]);
}

// 503 Service Unavailable
class ServiceUnavailableException extends HttpException {
  final int status = HttpStatus.SERVICE_UNAVAILABLE;
  final String message = "Service Unavailable";
  final Map<String, dynamic> data;
  const ServiceUnavailableException([this.data]);
}