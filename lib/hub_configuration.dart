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

  Map toMap() {
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

  Map toMap() {
    return {
      'name': name,
      'positionalParameters': positionalParameters.map((p) => p.toMap()).toList(),
      'namedParameters': namedParameters.map((p) => p.toMap()).toList(),
    };
  }
}

class HubDescriptor {
  String name;
  List<MethodDescriptor> methods;
  InstanceMirror hubMirror;

  Map toMap() {
    return {'name': name, 'methods': methods.map((m) => m.toMap()).toList()};
  }
}
