@TestOn('vm')
library shelf_exception_handler.test;

import 'dart:async';
import 'package:test/test.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:http_exception/http_exception.dart';
import 'package:shelf_exception_handler/shelf_exception_handler.dart';

void main() {
  const baseUrl = 'http://www.test.io';

  shelf.Request createShelfRequest(String method, String path) {
    final uri = Uri.parse(baseUrl + path);
    final headers = {'Accept': 'audio/*; q=0.2, audio/basic'};
    return shelf.Request(method, uri, headers: headers);
  }

  final defaultRequest = createShelfRequest('GET', '/asdf/qwer');

  final mw = exceptionHandler();

  test('exceptionResponse returns middleware', () {
    expect(mw is shelf.Middleware, isTrue);
  });

  test('middleware returns handler', () {
    expect(mw((request) {}) is Function, isTrue);
  });

  test('ignores non HttpExceptions', () {
    final handler = mw((request) => throw Exception());
    expect(handler(defaultRequest), throwsA(const TypeMatcher<Exception>()));
  });

  test('handles errors', () {
    final handler = mw((request) => throw const HttpException());
    expect(handler(defaultRequest) is Future, isTrue);
  });

  test('resolves normal response', () {
    final handler = mw((request) => shelf.Response.ok('asdf'));
    expect(handler(defaultRequest), completes);
  });

  test('handles HttpExceptions', () {
    final handler = mw((request) => throw const HttpException());
    expect(handler(defaultRequest), completes);
  });

  test('returns default 500', () {
    final handler = mw((request) => throw const HttpException());
    expect(handler(defaultRequest),
        completion(predicate<shelf.Response>((r) => r.statusCode == 500)));
  });

  test('returns correct 404', () {
    final handler =
        mw((request) => throw const HttpException(404, 'Not found'));
    expect(handler(defaultRequest),
        completion(predicate<shelf.Response>((r) => r.statusCode == 404)));
  });

  test('returns correct 301', () {
    final handler =
        mw((request) => throw const HttpException(301, 'Forbidden'));
    expect(handler(defaultRequest),
        completion(predicate<shelf.Response>((r) => r.statusCode == 301)));
  });
}
