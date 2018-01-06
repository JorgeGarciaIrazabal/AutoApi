import 'dart:async';
import 'dart:convert';
import 'dart:io';

String _host = InternetAddress.LOOPBACK_IP_V4.host;
const int _port = 4049;

Future main() async {
  var server = await HttpServer.bind(_host, _port);
  await for (var req in server) {
    ContentType contentType = req.headers.contentType;
    HttpResponse response = req.response;

    if (req.method == 'POST' && contentType?.mimeType == 'application/json') {
      try {
        String content = await req.transform(UTF8.decoder).join();
        Map json = JSON.decode(content);
        var fileName = req.uri.pathSegments.last;

        await new File(fileName).writeAsString(content, mode: FileMode.WRITE);

        req.response
          ..statusCode = HttpStatus.OK
          ..write('Wrote data for ${json['name']}.');
      } catch (e) {
        response
          ..statusCode = HttpStatus.INTERNAL_SERVER_ERROR
          ..write("Exception during file I/O: $e.");
      }
    } else {
      response
        ..statusCode = HttpStatus.METHOD_NOT_ALLOWED
        ..write("Unsupported request: ${req.method}.");
    }
    response.close();
  }
}
