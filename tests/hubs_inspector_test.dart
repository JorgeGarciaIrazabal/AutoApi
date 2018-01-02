import 'package:AutoApi/exceptions/exceptions.dart';
import 'package:AutoApi/hubs_inspector.dart';
import 'package:test/test.dart';

import 'hubs_mock_classes/duplicated_hubs_mock_class.dart' as duplicated;
import 'hubs_mock_classes/hubs_mock_classes.dart';

void main() {
	HubsInspector hubsInspector;

	setUp(() {
		List<Type> hubTypes = [
			OneMethod,
			TwoMethodsWidParameters,
			OneMethodWidDefaultValueParameters,
			OneMethodWidNamedParameters,
		];
		hubsInspector = new HubsInspector();
		hubsInspector.inspectHubs(hubTypes);
		expect(hubsInspector.hubsConfiguration.keys.length, equals(hubTypes.length));
	});

	test('OneMethod class gets only one method', () {
		expect(hubsInspector.hubsConfiguration.containsKey('OneMethod'), isTrue);
		var methodDescriptions = hubsInspector.hubsConfiguration['OneMethod']['methods'];
		expect(methodDescriptions.length, equals(1));
		expect(methodDescriptions[0]['name'], equals('myMethod'));
		expect(methodDescriptions[0]['positionalParameters'], equals([]));
		expect(methodDescriptions[0]['namesParameters'], equals([]));
	});

	test('TwoMethodsWidParameters class gets 2 methods and 2 parameters', () {
		expect(hubsInspector.hubsConfiguration.containsKey('TwoMethodsWidParameters'), isTrue);
		var methodDescriptions = hubsInspector
			.hubsConfiguration['TwoMethodsWidParameters']['methods'];
		expect(methodDescriptions.length, equals(2));
		expect(methodDescriptions[0]['name'], equals('m1'));
		expect(methodDescriptions[0]['positionalParameters'].length, equals(2));
		expect(methodDescriptions[0]['positionalParameters'][0], {
			'name': 'a1',
			'defaultValue': null
		});
		expect(methodDescriptions[0]['positionalParameters'][1], {
			'name': 'b1',
			'defaultValue': null
		});
		expect(methodDescriptions[1]['positionalParameters'][0], {
			'name': 'a2',
			'defaultValue': null
		});
		expect(methodDescriptions[1]['positionalParameters'][1], {
			'name': 'b2',
			'defaultValue': null
		});
		expect(methodDescriptions[0]['namesParameters'].length, equals(0));
	});

	test('OneMethodWidDefaultValueParameters class gets 1 method and parameters with default value', () {
		expect(hubsInspector.hubsConfiguration
			.containsKey('OneMethodWidDefaultValueParameters'), isTrue);
		var methodDescriptions = hubsInspector
			.hubsConfiguration['OneMethodWidDefaultValueParameters']['methods'];
		expect(methodDescriptions.length, equals(1));
		expect(methodDescriptions[0]['name'], equals('m1'));
		expect(methodDescriptions[0]['positionalParameters'].length, equals(2));
		expect(methodDescriptions[0]['positionalParameters'][0], {
			'name': 'a1',
			'defaultValue': null
		});
		expect(methodDescriptions[0]['positionalParameters'][1], {
			'name': 'b1',
			'defaultValue': 15
		});
		expect(methodDescriptions[0]['namesParameters'].length, equals(0));
	});

	test('OneMethodWidDefaultValueParameters class gets 1 method and parameters with named default value', () {
		expect(hubsInspector.hubsConfiguration.containsKey('OneMethodWidNamedParameters'), isTrue);
		var methodDescriptions = hubsInspector
			.hubsConfiguration['OneMethodWidNamedParameters']['methods'];
		expect(methodDescriptions.length, equals(1));
		expect(methodDescriptions[0]['name'], equals('m1'));
		expect(methodDescriptions[0]['namesParameters'].length, equals(2));
		expect(methodDescriptions[0]['namesParameters'][0], {
			'name': 'a1',
			'defaultValue': null
		});
		expect(methodDescriptions[0]['namesParameters'][1], {
			'name': 'b1',
			'defaultValue': 15
		});
		expect(methodDescriptions[0]['positionalParameters'].length, equals(0));
	});

	test('Duplicated hub names thorws DuplicatedHubNameException', () {
		hubsInspector = new HubsInspector();
		expect(() {
			hubsInspector.inspectHubs([
				OneMethod,
				duplicated.OneMethod,
			]);
		}, throwsA(new isInstanceOf<DuplicatedHubNameException>()));

		try {
			hubsInspector.inspectHubs([
				OneMethod,
				duplicated.OneMethod,
			]);
		} catch (e) {
			expect(e.toString(), contains("OneMethod"));
		}
	});
}