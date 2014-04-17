## Shelf Exception Response ##
[Shelf](http://pub.dartlang.org/packages/shelf) middleware for easily creating shelf.Responses by simply throwing
an HttpException.

### What problem does it solve ###
When creating web service you have to handle a lot of http responses simply informing the client about a server-side
error. Not all of those situations occure withing your request handlers but rather in some service classes or elsewhere
in your application. In your controller you would write something like:
```dart
// given a simple function that throws in certain conditions
String doJob() {
	if(!myCondition) {
		throw new MyError();
	}
	return "Successfully done Job";
}

// code in the request handler
try {
	String res = doJob();
	return new shelf.Response.ok(res);
} on MyError {
	return new shelf.Response.forbidden("You have to be logged in");
}
```

When using HttpExceptions and the exception response middleware your controller could be simplified to the following:

```dart
// given a simple function that throws HttpException in certain conditions
String doJob() {
	if(!myCondition) {
		throw new ForbiddenException();
	}
	return "Successfully done Job";
}

// code in request handler
String res = doJob();
return new shelf.Response.ok(res);
```

The thrown HttpException will be handled and an appropriate shelf.Response will be generated. The response will have
a correct Http status (eg.: 403), and the response body will be encoded in an acceptable format (Json, Xml, Text) using
[Tentacle Response Formatter](http://pub.dartlang.org/packages/tentacle_response_formatter).

### Example ###
```dart
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import '../lib/exception_response.dart';

// a simple shelf server with exception response enabled.
void main() {

  var handler = const shelf.Pipeline()
    // add exception response middleware to the pipeline
    .addMiddleware(exceptionResponse())
    .addHandler((shelf.Request request){
      // handler can now throw HttpException that is handled a formatted.
      throw new NotFoundException({"something":["additional", 4, true]});
    });

  io.serve(handler, 'localhost', 8080).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}
```

### Adding additional response data for the body ###
Every HttpException can take a data parameter that accepts a `Map<String, dynamic> data` in the constructor that
provides you with the ability to add custom data to the generated response. The fields status and message are always
added to the response data but can be overridden by data.

```dart
// adding custom data to response
throw new NotAcceptableException({
	"validation_errors": {
		"username": "to_long",
		"password": "not_contains_special_characters"
	}
});
```

### Add your own exception types ###
There are already predefined exceptions for the most common Http error code available but you may find that
there is a specific error code missing. In that case you can simply define your own HttpException type by
extending or implementing HttpException.

```dart
// creating custom exception
class IamATeapotException extends HttpException {
  final int status = 418;
  final String message = "I'm a teapot";
  final Map<String, dynamic> data;
  const IamATeapotException([this.data]);
}
```

### License ###
Apache 2.0