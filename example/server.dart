import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import '../lib/exception_response.dart';

void main() {
  var handler = const shelf.Pipeline()
    .addMiddleware(exceptionResponse())
    .addHandler((shelf.Request request){
      throw new NotFoundException({"something":["additional", 4, true]});
    });

  io.serve(handler, 'localhost', 8080).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}