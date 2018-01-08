import 'package:test/test.dart';

import 'http_handler_base_test.dart' as http;
import 'hubs_inspector_test.dart' as hubs;

void main() {
	group('http', http.main);
	group('hubs', hubs.main);
}