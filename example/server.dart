import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:http_exception/http_exception.dart';
import 'package:shelf_exception_handler/shelf_exception_handler.dart';

void main() {
  var handler = const shelf.Pipeline()
      .addMiddleware(exceptionHandler())
      .addHandler((shelf.Request request) {
    throw new NotFoundException({
      "something": ["additional", 4, true]
    });
  });

  io.serve(handler, 'localhost', 8080).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}
