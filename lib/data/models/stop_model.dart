class StopModel {
  StopModel({
    required this.code,
    required this.description,
    required this.datetime,
    required this.data,
  });
  late final String code;
  late final dynamic description;
  late final String datetime;
  late final List<Data> data;

  StopModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    datetime = json['datetime'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['description'] = description;
    _data['datetime'] = datetime;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.arrive,
    required this.stopInfo,
    required this.extraInfo,
    required this.incident,
  });
  late final List<Arrive> arrive;
  late final List<StopInfo> stopInfo;
  late final List<dynamic> extraInfo;
  late final Incident incident;

  Data.fromJson(Map<String, dynamic> json) {
    arrive = List.from(json['Arrive']).map((e) => Arrive.fromJson(e)).toList();
    stopInfo =
        List.from(json['StopInfo']).map((e) => StopInfo.fromJson(e)).toList();
    extraInfo = List.castFrom<dynamic, dynamic>(json['ExtraInfo']);
    incident = Incident.fromJson(json['Incident']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Arrive'] = arrive;
    _data['StopInfo'] = stopInfo.map((e) => e.toJson()).toList();
    _data['ExtraInfo'] = extraInfo;
    _data['Incident'] = incident.toJson();
    return _data;
  }
}

class Arrive {
  Arrive({
    required this.line,
    required this.stop,
    required this.isHead,
    required this.destination,
    required this.deviation,
    required this.bus,
    required this.geometry,
    required this.estimateArrive,
    required this.distanceBus,
    required this.positionTypeBus,
  });
  late final String line;
  late final String stop;
  late final String isHead;
  late final String destination;
  late final int deviation;
  late final int bus;
  late final Geometry geometry;
  late final int estimateArrive;
  late final int distanceBus;
  late final String positionTypeBus;

  Arrive.fromJson(Map<String, dynamic> json) {
    line = json['line'];
    stop = json['stop'];
    isHead = json['isHead'];
    destination = json['destination'];
    deviation = json['deviation'];
    bus = json['bus'];
    geometry = Geometry.fromJson(json['geometry']);
    estimateArrive = json['estimateArrive'];
    distanceBus = json['DistanceBus'];
    positionTypeBus = json['positionTypeBus'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['line'] = line;
    _data['stop'] = stop;
    _data['isHead'] = isHead;
    _data['destination'] = destination;
    _data['deviation'] = deviation;
    _data['bus'] = bus;
    _data['geometry'] = geometry.toJson();
    _data['estimateArrive'] = estimateArrive;
    _data['DistanceBus'] = distanceBus;
    _data['positionTypeBus'] = positionTypeBus;
    return _data;
  }
}

class StopInfo {
  StopInfo({
    required this.label,
    required this.stopLines,
    required this.description,
    required this.geometry,
    required this.direction,
  });
  late final String label;
  late final StopLines stopLines;
  late final String description;
  late final Geometry geometry;
  late final String direction;

  StopInfo.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    stopLines = StopLines.fromJson(json['StopLines']);
    description = json['Description'];
    geometry = Geometry.fromJson(json['geometry']);
    direction = json['Direction'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['label'] = label;
    _data['StopLines'] = stopLines.toJson();
    _data['Description'] = description;
    _data['geometry'] = geometry.toJson();
    _data['Direction'] = direction;
    return _data;
  }

  StopInfo copyWith({
    String? label,
    StopLines? stopLines,
    String? description,
    Geometry? geometry,
    String? direction,
  }) {
    return StopInfo(
      label: label ?? this.label,
      stopLines: stopLines ?? this.stopLines,
      description: description ?? this.description,
      geometry: geometry ?? this.geometry,
      direction: direction ?? this.direction,
    );
  }
}

class StopLines {
  StopLines({
    required this.data,
  });
  late final List<LineData> data;

  StopLines.fromJson(Map<String, dynamic> json) {
    data = List.from(json['Data']).map((e) => LineData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class LineData {
  LineData({
    required this.label,
    required this.line,
    required this.description,
    required this.distance,
    required this.to,
  });
  late final String label;
  late final String line;
  late final String description;
  late final int distance;
  late final String to;

  LineData.fromJson(Map<String, dynamic> json) {
    label = json['Label'];
    line = json['line'];
    description = json['Description'];
    distance = json['distance'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Label'] = label;
    _data['line'] = line;
    _data['Description'] = description;
    _data['distance'] = distance;
    _data['to'] = to;
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

class Incident {
  Incident();

  Incident.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}
