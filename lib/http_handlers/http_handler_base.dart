import 'dart:async';

import 'package:meta/meta.dart';

import '../exceptions/exceptions.dart';
import '../hub_configuration.dart';
import '../hubs_inspector.dart';
import '../serializer.dart';

abstract class HttpHandlerBase {
	final String REQUEST_PARAMETER_NAME = 'request_';
	HubsInspector _hubInspector = new HubsInspector();
	Serializer _serializer = new Serializer();
	int _messageId = 0;

	HubsInspector get hubInspector => _hubInspector;

	Serializer get serializer => _serializer;

	// todo add enum for mode Production, Develop, DevelopVerbose etc

	@protected
	Future<String> handleRequest(Map body, Object request) async {
		if (!this._hubInspector.hubDescriptions.containsKey(body['hub'])) {
			throw new HubNotFoundException(body['hub']);
		}

		HubDescriptor hubDescriptor = this._hubInspector.hubDescriptions[body['hub']];
		body = _includeRequestParam(body, request);

		Map namedParameters = {};
		(body['namedParameters'] ?? {}).forEach((k, v) {
			namedParameters[new Symbol(k)] = v;
		});

		Object hubResult = hubDescriptor.hubMirror
			.invoke(
			new Symbol(body['method']),
			body['positionalParameters'] ?? [],
			namedParameters,
		)
			.reflectee;

		Object result = hubResult is Future ? await hubResult : hubResult;

		return this.constructOkResponse(result);
	}

	Future start() async {
		if (!this._hubInspector.codeInspected) {
			this._hubInspector.inspectCode();
		}
		return await this.serverListen();
	}

	@protected
	Future serverListen();

	@protected
	String constructOkResponse(Object result) {
		Map response = {
			'result': result,
			'id': this._messageId++,
		};
		return this._serializer.serialize(response);
	}

	Map _includeRequestParam(Map body, Object request) {
		HubDescriptor hubDescriptor = this._hubInspector.hubDescriptions[body['hub']];
		MethodDescriptor methodDescriptor;
		try {
			methodDescriptor = hubDescriptor.methods
				.firstWhere((m) => m.name == body['method']);
		} on StateError catch (_) {
			throw new MethodNotFoundException(body['hub'], body['method']);
		}

		ParameterDescriptor requestParam = methodDescriptor.positionalParameters
			.firstWhere((p) => p.name == this.REQUEST_PARAMETER_NAME, orElse: () => null);
		if (requestParam != null) {
			body['positionalParameters']
				.insert(methodDescriptor.positionalParameters.indexOf(requestParam), request);
		} else {
			requestParam = methodDescriptor.namedParameters
				.firstWhere((p) => p.name == this.REQUEST_PARAMETER_NAME, orElse: () => null);
			if (requestParam != null) {
				body['namedParameters'][this.REQUEST_PARAMETER_NAME] = request;
			}
		}
		return body;
	}
}
