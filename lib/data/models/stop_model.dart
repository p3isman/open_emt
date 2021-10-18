class StopModel {
  StopModel({
    required this.code,
    required this.description,
    required this.datetime,
    required this.data,
  });
  late final String code;
  late final String description;
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
    _data['Arrive'] = arrive.map((e) => e.toJson()).toList();
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

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });
  late final String type;
  late final List<int> coordinates;

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = List.castFrom<dynamic, int>(json['coordinates']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['coordinates'] = coordinates;
    return _data;
  }
}

class StopInfo {
  StopInfo({
    required this.lines,
    required this.stopId,
    required this.stopName,
    required this.geometry,
    required this.direction,
  });
  late final List<Lines> lines;
  late final String stopId;
  late final String stopName;
  late final Geometry geometry;
  late final String direction;

  StopInfo.fromJson(Map<String, dynamic> json) {
    lines = List.from(json['lines']).map((e) => Lines.fromJson(e)).toList();
    stopId = json['stopId'];
    stopName = json['stopName'];
    geometry = Geometry.fromJson(json['geometry']);
    direction = json['Direction'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lines'] = lines.map((e) => e.toJson()).toList();
    _data['stopId'] = stopId;
    _data['stopName'] = stopName;
    _data['geometry'] = geometry.toJson();
    _data['Direction'] = direction;
    return _data;
  }
}

class Lines {
  Lines({
    required this.label,
    required this.line,
    required this.nameA,
    required this.nameB,
    required this.metersFromHeader,
    required this.to,
    required this.color,
  });
  late final String label;
  late final String line;
  late final String nameA;
  late final String nameB;
  late final int metersFromHeader;
  late final String to;
  late final String color;

  Lines.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    line = json['line'];
    nameA = json['nameA'];
    nameB = json['nameB'];
    metersFromHeader = json['metersFromHeader'];
    to = json['to'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['label'] = label;
    _data['line'] = line;
    _data['nameA'] = nameA;
    _data['nameB'] = nameB;
    _data['metersFromHeader'] = metersFromHeader;
    _data['to'] = to;
    _data['color'] = color;
    return _data;
  }
}

class Incident {
  Incident({
    required this.listaIncident,
  });
  late final ListaIncident listaIncident;

  Incident.fromJson(Map<String, dynamic> json) {
    listaIncident = ListaIncident.fromJson(json['ListaIncident']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ListaIncident'] = listaIncident.toJson();
    return _data;
  }
}

class ListaIncident {
  ListaIncident({
    required this.data,
  });
  late final List<Data> data;

  ListaIncident.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}
