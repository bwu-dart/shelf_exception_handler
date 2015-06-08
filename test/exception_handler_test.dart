@TestOn('vm')
library shelf_exception_handler.test;

import 'dart:async';
import 'package:test/test.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:http_exception/http_exception.dart';
import 'package:shelf_exception_handler/shelf_exception_handler.dart';

void main() {
  String baseUrl = "http://www.test.io";

  shelf.Request createShelfRequest(String method, String path) {
    Uri uri = Uri.parse(baseUrl + path);
    Map<String, String> headers = {'Accept': 'audio/*; q=0.2, audio/basic'};
    return new shelf.Request(method, uri, headers: headers);
  }

  shelf.Request defaultRequest = createShelfRequest('GET', '/asdf/qwer');

  shelf.Middleware mw = exceptionHandler();

  test("exceptionResponse returns middleware", () {
    expect(mw is shelf.Middleware, isTrue);
  });

  test("middleware returns handler", () {
    expect(mw((request) {}) is Function, isTrue);
  });

  test("ignores non HttpExceptions", () {
    var handler = mw((request) => throw new Exception());
    expect(handler(defaultRequest), throws);
  });

  test("handles errors", () {
    var handler = mw((request) => throw new HttpException());
    expect(handler(defaultRequest) is Future, isTrue);
  });

  test("resolves normal response", () {
    var handler = mw((request) => new shelf.Response.ok("asdf"));
    expect(handler(defaultRequest), completes);
  });

  test("handles HttpExceptions", () {
    var handler = mw((request) => throw new HttpException());
    expect(handler(defaultRequest), completes);
  });

  test("returns default 500", () {
    var handler = mw((request) => throw new HttpException());
    expect(handler(defaultRequest),
        completion(predicate((r) => r.statusCode == 500)));
  });

  test("returns correct 404", () {
    var handler = mw((request) => throw new HttpException(404, "Not found"));
    expect(handler(defaultRequest),
        completion(predicate((r) => r.statusCode == 404)));
  });

  test("returns correct 301", () {
    var handler = mw((request) => throw new HttpException(301, "Forbidden"));
    expect(handler(defaultRequest),
        completion(predicate((r) => r.statusCode == 301)));
  });
}
