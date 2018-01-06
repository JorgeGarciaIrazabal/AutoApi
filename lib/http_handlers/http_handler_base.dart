import 'dart:async';

import 'package:meta/meta.dart';

import '../hub_configuration.dart';
import '../hubs_inspector.dart';
import '../serializer.dart';

abstract class HttpHandlerBase {
  HubsInspector _hubInspector = new HubsInspector();
  Serializer _serializer = new Serializer();

  // todo add enum for mode Production, Develop, DevelopVerbose etc

  @protected
  Future handleRequest(Map body, Object request) async {
    HubDescriptor hubDescriptor = this._hubInspector.hubDescriptions[body['hub']];
    // todo, add request to parameters if the method has _request in their parameters
    Object result = hubDescriptor.hubMirror.invoke(
        body['method'], body['positionalParameters'] ?? [], body['namedParameters'] ?? null);

    if (result is Future) {
      return await result;
    }
    return result;
  }

  Future start() async {
    this._hubInspector.inspectCode();
    this.serverListen();
  }

  @protected
  Future serverListen();

  @protected
  String constructOkResponse({Object result, int id}) {
    Map response = {
      'result': result,
      'id': id,
    };
    return this._serializer.serialize(response);
  }

  @protected
  String constructErrorResponse({Exception exception, StackTrace stackTrace, int id}) {
    Map response = {
      'error': exception.toString(),
      'stackTrace': stackTrace.toString(),
      'id': id,
    };
    return this._serializer.serialize(response);
  }
}
