library shelf_exception_response.test.exception_response;

import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_exception_response/exception_response.dart';

void main() {

  shelf.Middleware mw = exceptionResponse();

  test("exceptionResponse returns middleware", () {
    expect(mw is shelf.Middleware, isTrue);
  });

  test("middleware returns handler", () {
    expect(mw((request){}) is Function, isTrue);
  });

  test("ignores non HttpExceptions", () {
    var handler = mw((request) => throw new Exception());
    expect(handler(""), throws);
  });

  test("handles errors", () {
    var handler = mw((request) => throw new HttpException());
    expect(handler("") is Future, isTrue);
  });

  test("handles HttpExceptions", () {
    var handler = mw((request) => throw new HttpException());
    expect(handler(""), completes);
  });

  test("returns default 500", () {
    var handler = mw((request) => throw new HttpException());
    expect(handler(""), completion(predicate((r) => r.statusCode == 500)));
  });

  test("returns correct 404", () {
    var handler = mw((request) => throw new HttpException(404, "Not found"));
    expect(handler(""), completion(predicate((r) => r.statusCode == 404)));
  });

  test("returns correct 301", () {
    var handler = mw((request) => throw new HttpException(301, "Forbidden"));
    expect(handler(""), completion(predicate((r) => r.statusCode == 301)));
  });

}