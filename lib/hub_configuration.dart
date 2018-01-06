import 'dart:mirrors';

class ParameterDescriptor {
  String name;
  ParameterMirror parameterMirror;
  Object defaultValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParameterDescriptor && name == other.name && defaultValue == other.defaultValue;

  @override
  int get hashCode => name.hashCode ^ defaultValue.hashCode;

  Map toJson() {
    return {
      'name': this.name,
      'defaultValue': defaultValue,
    };
  }
}

class MethodDescriptor {
  String name;
  List<ParameterDescriptor> positionalParameters;
  List<ParameterDescriptor> namedParameters;
  MethodMirror methodMirror;

  Map toJson() {
    return {
      'name': name,
      'positionalParameters': positionalParameters.map((p) => p.toJson()),
      'namedParameters': namedParameters.map((p) => p.toJson()),
    };
  }
}

class HubDescriptor {
  String name;
  List<MethodDescriptor> methods;
  InstanceMirror hubMirror;

  Map toJson() {
    return {'name': name, 'methos': methods.map((m) => m.toJson())};
  }
}
