import 'dart:mirrors';

import 'exceptions/exceptions.dart';
import 'hub.dart';
import 'hub_configuration.dart';

class HubsInspector {
	bool codeInspected = false;
	Map<String, HubDescriptor> _hubsDescriptions = new Map<String, HubDescriptor>();

	Map<String, HubDescriptor> get hubDescriptions => _hubsDescriptions;

	void inspectCode() {
		List<ClassMirror> hubsMirrors = this.findHubs();
		return this._inspectHubs(hubsMirrors);
	}

	List<ClassMirror> findHubs() {
		ClassMirror hubMirror = reflectClass(Hub);

		return currentMirrorSystem()
				.libraries
				.values
				.where((lib) => lib.uri.scheme == "package" || lib.uri.scheme == "file")
				.expand((lib) => lib.declarations.values)
				.where((lib) {
			return lib is ClassMirror && lib.isSubclassOf(hubMirror) && lib != hubMirror;
		}).toList();
	}

	Hub getHubInstance(Type hubType) {
		ClassMirror hubMirror = reflectClass(hubType);
		String hubName = MirrorSystem.getName(hubMirror.simpleName);
		return this._hubsDescriptions[hubName].hubMirror.reflectee;
	}

	void _inspectHubs(List<ClassMirror> hubClassMirrors) {
		hubClassMirrors.forEach((hubClassMirror) {
			String hubName = MirrorSystem.getName(hubClassMirror.simpleName);
			if (this._hubsDescriptions.containsKey(hubName)) {
				throw new DuplicatedHubNameException(hubName);
			}
			InstanceMirror hubMirror = hubClassMirror.newInstance(const Symbol(''), []);
			this._hubsDescriptions[hubName] = new HubDescriptor()
				..name = hubName
				..hubMirror = hubMirror
				..methods = this._describeMethods(hubMirror);
		});
		this.codeInspected = true;
	}

	List<MethodDescriptor> _describeMethods(InstanceMirror hubMirror) {
		ClassMirror hubClassMirror = hubMirror.type;

		return hubClassMirror.instanceMembers.values
				.where(_isApiMethod)
				.toList()
				.map(_getParameterDescriptions)
				.toList();
	}

	MethodDescriptor _getParameterDescriptions(methodMirror) {
		List<ParameterMirror> parameters = methodMirror.parameters;
		List<ParameterDescriptor> positionalParameters = [];
		List<ParameterDescriptor> namedParameters = [];

		for (ParameterMirror parameter in parameters) {
			ParameterDescriptor parameterMap = new ParameterDescriptor()
				..name = MirrorSystem.getName(parameter.simpleName)
				..defaultValue = parameter.defaultValue?.reflectee
				..parameterMirror = parameter;

			parameter.isNamed
					? namedParameters.add(parameterMap)
					: positionalParameters.add(parameterMap);
		}

		return new MethodDescriptor()
			..name = MirrorSystem.getName(methodMirror.simpleName)
			..positionalParameters = positionalParameters
			..namedParameters = namedParameters
			..methodMirror = methodMirror;
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
