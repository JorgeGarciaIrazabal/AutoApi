import 'package:AutoApi/hub.dart';

class OneMethod extends Hub {
	String myMethod() {
		return '3';
	}
}

class TwoMethodsWidParameters extends Hub {
	String m1(a1, b1) {
		return '3';
	}

	String m2(a2, b2) {
		return '3';
	}
}

class OneMethodWidDefaultValueParameters extends Hub {
	String m1([a1, b1 = 15]) {
		return '3';
	}
}

class OneMethodWidNamedParameters extends Hub {
	String m1({a1, b1 = 15}) {
		return '3';
	}
}