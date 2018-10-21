library shelf_exception_handler;

import 'dart:async';
import 'dart:io' show HttpHeaders;

import 'package:http_exception/http_exception.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_response_formatter/shelf_response_formatter.dart';

export 'package:shelf_exception_handler/shelf_exception_handler.dart';

ResponseFormatter formatter = ResponseFormatter();

/// A middleware that allows handlers to simply throw [HttpException]s
/// instead of having to create and return a non successful [shelf.Response].
///
/// Example:
/// (request) {
///    if(notA) {
///      throw(301, "You have to be A");
///    }
///    return new Response();
/// }
// ignore: avoid_types_on_closure_parameters
shelf.Middleware exceptionHandler() => (shelf.Handler handler) =>
// ignore: avoid_types_on_closure_parameters
    (shelf.Request request) =>
        Future.sync(() => handler(request)).then((response) => response)
            // ignore: avoid_types_on_closure_parameters
            .catchError((Object error, StackTrace stackTrace) {
          final result = formatter.formatResponse(
              request, (error as HttpException).toMap());
          return shelf.Response((error as HttpException).status,
              body: result.body,
              headers: {HttpHeaders.contentTypeHeader: result.contentType});
        }, test: (e) => e is HttpException);
