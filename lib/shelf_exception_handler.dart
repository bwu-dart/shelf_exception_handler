library shelf_exception_handler;

import 'dart:io' show HttpHeaders;
import 'dart:async';
import 'package:shelf/shelf.dart' as shelf;
import 'package:http_exception/http_exception.dart';
export 'package:shelf_exception_handler/shelf_exception_handler.dart';
import 'package:shelf_response_formatter/shelf_response_formatter.dart';

ResponseFormatter formatter = new ResponseFormatter();

/// A middleware that allows handlers to simply throw [HttpExceptions]
/// instead of having to create and return a non successful [Response].
///
/// Example:
/// (request) {
///    if(notA) {
///      throw(301, "You have to be A");
///    }
///    return new Response();
/// }
shelf.Middleware exceptionHandler() {
  return (shelf.Handler handler) {
    return (shelf.Request request) {
      return new Future.sync(() => handler(request))
          .then((response) => response)
          .catchError((error, stackTrace) {
        FormatResult result = formatter.formatResponse(request, error.toMap());
        return new shelf.Response(error.status,
            body: result.body,
            headers: {HttpHeaders.contentTypeHeader: result.contentType});
      }, test: (e) => e is HttpException);
    };
  };
}
