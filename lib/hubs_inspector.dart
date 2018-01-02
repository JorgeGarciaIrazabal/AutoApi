import 'dart:mirrors';

import 'exceptions/exceptions.dart';
import 'hub.dart';

class HubsInspector {
	Map _hubsConfiguration = new Map();

	Map get hubsConfiguration => _hubsConfiguration;

	void inspectHubs(List<ClassMirror> hubClassMirrors) {
		hubClassMirrors.forEach((hubClassMirror) {
			String hubName = MirrorSystem.getName(hubClassMirror.simpleName);
			if (this._hubsConfiguration.containsKey(hubName)) {
				throw new DuplicatedHubNameException(hubName);
			}
			InstanceMirror hubMirror = hubClassMirror.newInstance(const Symbol(''), []);
			this._hubsConfiguration[hubName] = {
				'hubMirror': hubMirror,
				'methods': this._describeMethods(hubMirror),
			};
		});
	}

	List<ClassMirror> findHubs() {
		ClassMirror hubMirror = reflectClass(Hub);

		return currentMirrorSystem()
			.libraries
			.values
			.where((lib) => lib.uri.scheme == "package" || lib.uri.scheme == "file")
			.expand((lib) => lib.declarations.values)
			.where((lib) {
			return lib is ClassMirror &&
				lib.isSubclassOf(hubMirror) &&
				lib != hubMirror;
		}).toList();
	}

	void inspectCode() {
		List<ClassMirror> hubsMirrors = this.findHubs();
		return this.inspectHubs(hubsMirrors);
	}

	List<Map> _describeMethods(InstanceMirror hubMirror) {
		ClassMirror hubClassMirror = hubMirror.type;

		return hubClassMirror.instanceMembers.values
			.where(_isApiMethod)
			.toList()
			.map(_getParameterDescriptions)
			.toList();
	}

	Map _getParameterDescriptions(methodMirror) {
		List <ParameterMirror> parameters = methodMirror.parameters;
		List positionalParameters = [];
		List namedParameters = [];

		for (ParameterMirror parameter in parameters) {
			Map parameterMap = {
				'name': MirrorSystem.getName(parameter.simpleName),
				'defaultValue': parameter.defaultValue?.reflectee,
			};

			parameter.isNamed ?
			namedParameters.add(parameterMap) :
			positionalParameters.add(parameterMap);
		}

		return {
			'name': MirrorSystem.getName(methodMirror.simpleName),
			'positionalParameters': positionalParameters,
			"namesParameters": namedParameters
		};
	}

	bool _isApiMethod(MethodMirror methodMirror) {
		return methodMirror.isRegularMethod &&
			!methodMirror.isAbstract &&
			!methodMirror.isOperator &&
			!methodMirror.isPrivate &&
			!methodMirror.isConstructor &&
			!methodMirror.isFactoryConstructor &&
			!methodMirror.isGetter &&
			!methodMirror.isRedirectingConstructor &&
			!methodMirror.isSynthetic &&
			!(methodMirror.simpleName == new Symbol('toString')) &&
			!(methodMirror.simpleName == new Symbol('noSuchMethod'));
	}
}
