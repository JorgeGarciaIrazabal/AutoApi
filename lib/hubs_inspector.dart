import 'dart:mirrors';

import 'exceptions/exceptions.dart';

class HubsInspector {
	Map _hubsConfiguration = new Map();

	Map get hubsConfiguration => _hubsConfiguration;

	// todo: remove parameters once we fix `getSubClasses`
	// todo: use objects instead of dictionaries
	void inspectHubs(List<Type> hubs) {
		hubs.forEach((hub) {
			ClassMirror hubClassMirror = reflectClass(hub);
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

	List<Map> _describeMethods(InstanceMirror hubMirror) {
		ClassMirror hubClassMirror = hubMirror.type;

		return hubClassMirror.instanceMembers.values
			.where(_isApiMethod)
			.toList()
			.map(_getParameterDescriptions)
			.toList();
	}

	_getParameterDescriptions(methodMirror) {
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

	static List<Type> getSubclasses(Type type) {
		List<Type> subClasses = [];
		MirrorSystem mirrorSystem = currentMirrorSystem();

		mirrorSystem.isolate.rootLibrary.classes.forEach((s, c) {
			if (c.superclass == type) {
				subClasses.add(c);
			}
		});
		return subClasses;
	}
}
