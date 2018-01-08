import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'http_handler_base.dart';

class HttpServerHandler extends HttpHandlerBase {
	HttpServer server;

	Future bindServer(dynamic address, int port,
		{int backlog: 0, bool v6Only: false, bool shared: false})
	async {
		this.server =
		await HttpServer.bind(address, port, backlog: backlog, v6Only: v6Only, shared: shared);
	}

	@override
	Future serverListen() async {
		await for (var request in this.server) {
			ContentType contentType = request.headers.contentType;
			HttpResponse response = request.response;
			try {
				if (request.method == 'POST' && contentType?.mimeType == 'application/json') {
					String content = await request.transform(UTF8.decoder).join();
					Map json = JSON.decode(content);
					String result = await this.handleRequest(json, request);
					response
						..statusCode = HttpStatus.OK
						..write(result);
				}
			} catch (e) {
				response
					..statusCode = HttpStatus.INTERNAL_SERVER_ERROR
					..write("Exception during file I/O: $e.");
			} finally {
				response.close();
			}
		}
	}
}
