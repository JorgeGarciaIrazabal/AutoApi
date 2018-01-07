import '../../lib/hub.dart';

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

class ExtendedClass extends OneMethod {
	String m1({a1, b1 = 15}) {
		return '3';
	}
}

class HubMock extends Hub {
	List positionalParameters = [];
	Map namedParameters = {};

	Object pp([a1, b1 = 15]) {
		this.positionalParameters = [a1, b1];
		return a1;
	}

	Object np({a1, b1 = 15}) {
		this.namedParameters = {
			'a1': a1,
			'b1': b1,
		};
		return a1;
	}

	Object ppRequest(a1, request_, [b1 = 15]) {
		this.positionalParameters = [a1, request_, b1];
		return a1;
	}

	Object npRequest({a1, request_, b1 = 15}) {
		this.namedParameters = {
			'a1': a1,
			'request_': request_,
			'b1': b1,
		};
		return a1;
	}
}