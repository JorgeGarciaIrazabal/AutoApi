import '../../lib/hub.dart';

class OneMethod extends Hub {
	String myMethod() {
		return '3';
	}
}

class TwoMethodsWidParameters extends Hub {
	String m1(Object a1, Object b1) {
		return '3';
	}

	String m2(Object a2, Object b2) {
		return '3';
	}
}

class OneMethodWidDefaultValueParameters extends Hub {
	String m1([Object a1, Object b1 = 15]) {
		return '3';
	}
}

class OneMethodWidNamedParameters extends Hub {
	String m1({Object a1, Object b1 = 15}) {
		return '3';
	}
}

class ExtendedClass extends OneMethod {
	String m1({Object a1, Object b1 = 15}) {
		return '3';
	}
}

class HubMock extends Hub {
	List positionalParameters = [];
	Map namedParameters = {};

	Object pp([Object a1, Object b1 = 15]) {
		this.positionalParameters = [a1, b1];
		return a1;
	}

	Object np({Object a1, Object b1 = 15}) {
		this.namedParameters = {
			'a1': a1,
			'b1': b1,
		};
		return a1;
	}

	Object ppRequest(Object a1, Object request_, [Object b1 = 15]) {
		this.positionalParameters = [a1, request_, b1];
		return a1;
	}

	Object npRequest({Object a1, Object request_, Object b1 = 15}) {
		this.namedParameters = {
			'a1': a1,
			'request_': request_,
			'b1': b1,
		};
		return a1;
	}
}