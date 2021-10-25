class StopListModel {
  StopListModel({
    required this.code,
    required this.data,
    required this.description,
    required this.datetime,
  });
  late final String code;
  late final List<Data> data;
  late final String description;
  late final String datetime;

  StopListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
    description = json['description'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['description'] = description;
    _data['datetime'] = datetime;
    return _data;
  }
}

class Data {
  Data({
    required this.node,
    required this.geometry,
    required this.wifi,
    required this.lines,
    required this.name,
  });
  late final String node;
  late final Geometry geometry;
  late final String wifi;
  late final List<String> lines;
  late final String name;

  Data.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    geometry = Geometry.fromJson(json['geometry']);
    wifi = json['wifi'];
    lines = List.castFrom<dynamic, String>(json['lines']);
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['node'] = node;
    _data['geometry'] = geometry.toJson();
    _data['wifi'] = wifi;
    _data['lines'] = lines;
    _data['name'] = name;
    return _data;
  }
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });
  late final String type;
  late final List<double> coordinates;

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = List.castFrom<dynamic, double>(json['coordinates']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['coordinates'] = coordinates;
    return _data;
  }
}
