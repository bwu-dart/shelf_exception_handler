library shelf_exception_response.exception_response;
import 'dart:async';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_exception_response/exception.dart';
export 'package:shelf_exception_response/exception.dart';

/**
 * A middleware that allows handlers to simply throw [HttpExceptions]
 * instead of having to create and return a non successful [Response].
 *
 * Example:
 * (request) {
 *    if(notA) {
 *      throw(301, "You have to be A");
 *    }
 *    return new Response();
 * }
 */
shelf.Middleware exceptionResponse() {
  return shelf.createMiddleware(errorHandler: (error, stackTrace) {
    if(error is HttpException) {
      return new shelf.Response(error.status, body: _formatResponseBody(error));
    }
    throw error;
  });
}

/**
 * Formats toString should be replaceable with Json, XML and other
 * formatter.
 * TODO: Use accept header for formatting.
 */
_formatResponseBody(HttpException e) {
  return e.toString();
}
