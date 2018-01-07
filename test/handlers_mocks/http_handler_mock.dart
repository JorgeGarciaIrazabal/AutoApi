import 'dart:async';

import '../../lib/http_handlers/http_handler_base.dart';

class HttpHandlerMock extends HttpHandlerBase {
	Map body = {};
	Object request = {};

	@override
	Future serverListen() async {
		await new Future.delayed(const Duration(microseconds: 1));
		return await this.handleRequest(this.body, request);
	}

}