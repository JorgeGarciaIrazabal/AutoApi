import 'dart:convert';

import 'package:test/test.dart';

import '../lib/hubs_inspector.dart';
import 'handlers_mocks/http_handler_mock.dart';
import 'hubs_mock_classes/hubs_mock_classes.dart';

void main() {
	HubsInspector hubsInspector;
	HttpHandlerMock httpHandlerMock;
	HubMock hubMock;

	setUp(() {
		httpHandlerMock = new HttpHandlerMock();
		hubsInspector = httpHandlerMock.hubInspector;
		hubsInspector.inspectCode();
		hubMock = hubsInspector.getHubInstance(HubMock);
	});

	group('handleRequest', () {
		test('hub function is called', () async {
			httpHandlerMock
				..body = {
					'method': 'pp',
					'hub': 'HubMock',
					'positionalParameters': [1, 3],
					'namedParameters': {},
				}
				..request = 'my_request';
			String stringResult = await httpHandlerMock.start();
			Object result = JSON.decode(stringResult)['result'];
			expect(hubMock.positionalParameters, [1, 3]);
			expect(hubMock.namedParameters, {});
			expect(result, 1);
		});

		test('hub functions is called using default position value', () async {
			httpHandlerMock
				..body = {
					'method': 'pp',
					'hub': 'HubMock',
					'positionalParameters': [5],
					'namedParameters': {},
				}
				..request = 'my_request';
			String stringResult = await httpHandlerMock.start();
			Object result = JSON.decode(stringResult)['result'];
			expect(hubMock.positionalParameters, [5, 15]);
			expect(hubMock.namedParameters, {});
			expect(result, 5);
		});

		test('hub functions is called using default value', () async {
			httpHandlerMock
				..body = {
					'method': 'np',
					'hub': 'HubMock',
					'positionalParameters': [],
					'namedParameters': {'a1': 1, 'b1': 3},
				}
				..request = 'my_request';
			String stringResult = await httpHandlerMock.start();
			Object result = JSON.decode(stringResult)['result'];
			expect(hubMock.namedParameters, {'a1': 1, 'b1': 3});
			expect(hubMock.positionalParameters, []);
			expect(result, 1);
		});

		test('hub functions is called using default named value', () async {
			httpHandlerMock
				..body = {
					'method': 'np',
					'hub': 'HubMock',
					'positionalParameters': [],
					'namedParameters': {'a1': 1},
				}
				..request = 'my_request';
			String stringResult = await httpHandlerMock.start();
			Object result = JSON.decode(stringResult)['result'];
			expect(hubMock.namedParameters, {'a1': 1, 'b1': 15});
			expect(hubMock.positionalParameters, []);
			expect(result, 1);
		});

		test('hub functions is called using default position and request value', () async {
			httpHandlerMock
				..body = {
					'method': 'ppRequest',
					'hub': 'HubMock',
					'positionalParameters': [5],
					'namedParameters': {},
				}
				..request = -3;
			String stringResult = await httpHandlerMock.start();
			Object result = JSON.decode(stringResult)['result'];
			expect(hubMock.positionalParameters, [5, -3, 15]);
			expect(hubMock.namedParameters, {});
			expect(result, 5);
		});

		test('hub functions is called with request_ as name parameter', () async {
			httpHandlerMock
				..body = {
					'method': 'npRequest',
					'hub': 'HubMock',
					'positionalParameters': [],
					'namedParameters': {'a1': 1, 'b1': 3},
				}
				..request = 0;
			String stringResult = await httpHandlerMock.start();
			Object result = JSON.decode(stringResult)['result'];
			expect(hubMock.namedParameters, {'a1': 1, 'b1': 3, 'request_': 0});
			expect(hubMock.positionalParameters, []);
			expect(result, 1);
		});

		test('Exception is throw if method is not found', () {
			httpHandlerMock
				..body = {
					'method': 'noMethod',
					'hub': 'HubMock',
					'positionalParameters': [],
					'namedParameters': {'a1': 1, 'b1': 3},
				};
			expect(httpHandlerMock.start(), throwsException);
			expect(hubMock.namedParameters, {});
			expect(hubMock.positionalParameters, []);
		});

		test('Exception is throw if hub is not found', () {
			httpHandlerMock
				..body = {
					'method': 'pp',
					'hub': 'HubNotFound',
					'positionalParameters': [],
					'namedParameters': {'a1': 1, 'b1': 3},
				};
			expect(httpHandlerMock.start(), throwsException);
			expect(hubMock.namedParameters, {});
			expect(hubMock.positionalParameters, []);
		});

		test('Exception is throw if parameters don\'t match', () {
			httpHandlerMock
				..body = {
					'method': 'pp',
					'hub': 'HubMock',
					'positionalParameters': [1, 4, 6],
					'namedParameters': {},
				};
			expect(httpHandlerMock.start(), throwsNoSuchMethodError);
			expect(hubMock.namedParameters, {});
			expect(hubMock.positionalParameters, []);
		});
	});

	group('handleRequest', () {

	});
}
