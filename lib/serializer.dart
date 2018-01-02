import 'dart:convert';
import 'dart:mirrors';

class Serializer {
	String serialize(obj) {
		return JSON.encode(_jsonize(obj
		)
		);
	}

	_jsonize(var obj) {
		if (obj is String || obj is num || obj is bool) {
			return obj;
		} else if (obj is DateTime) {
			return _jsonize({"__date_time__": obj
				.toUtc()
				.millisecondsSinceEpoch}
			);
		} else if (obj is List) {
			return obj.map((item) {
				return _jsonize(item
				);
			});
		} else if (obj is Map) {
			obj.forEach((key, item) {
				obj[key] = _jsonize(item
				);
			});
			return obj;
		} else {
			Map map = new Map();
			InstanceMirror im = reflect(obj);
			ClassMirror cm = im.type;
			var decls = cm.declarations.values.where((dm) => dm is VariableMirror
			);
			decls.forEach((dm) {
				var key = MirrorSystem.getName(dm.simpleName
				);
				var val = im
					.getField(dm.simpleName
				)
					.reflectee;
				map[key] = _jsonize(val
				);
			});
			return map;
		}
	}

	Map unserialize(objStr) {
		Map objMap = JSON.decode(objStr
		);
		return _unjsonize(objMap
		);
	}

	_unjsonize(obj) {
		if (obj is String || obj is num || obj is bool) {
			return obj;
		} else if (obj is List) {
			return obj.map((item) {
				return _unjsonize(item
				);
			});
		} else if (obj is Map) {
			if (obj.containsKey("__date_time__"
			)) {
				return new DateTime.fromMillisecondsSinceEpoch(obj["__date_time__"],
					isUtc: true
				);
			}
			obj.forEach((key, item) {
				obj[key] = _unjsonize(item
				);
			});
			return obj;
		}
	}
}
