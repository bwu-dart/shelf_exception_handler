library shelf_exception_response.exception;

/**
 * HTTP exception enables to immediately stop request execution
 * and send an appropriate error message to the client. Message should
 * be an correctly encoded response (eg.: Json) and status a valid
 * and appropriate HTTP status code.
 */
class HttpException implements Exception {

  final int status;
  final String message;

  const HttpException([this.status = 500, this.message = "Internal server error"]);

  Map<String, dynamic> get toMap {
    return {
        "status": status, "message": message
    };
  }

  String toString() {
    return "Http status ${status.toString()}: ${message}";
  }

  String format() {
    return "";
  }
}

// 404 Exception
class NotFoundException extends HttpException {
  final int status = 404;
  final String message = "Not Found";
}