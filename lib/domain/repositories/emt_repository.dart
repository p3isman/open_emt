import 'package:dio/dio.dart';
import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/data/services/emt_service.dart';

class EMTRepository {
  final EMTService emtService;
  bool isLoggedIn = false;

  EMTRepository({required this.emtService});

  Future<StopModel?> getStopInfo(String stopId) async {
    if (!isLoggedIn) {
      try {
        if (await emtService.login()) {
          isLoggedIn = true;
        }
      } on DioError {
        rethrow;
      }
    }

    int numberOfStops;

    try {
      numberOfStops = await getNumberOfStops();
    } on DioError {
      rethrow;
    }

// Check if stop number is valid
    stopId = stopId.trim();
    if (int.parse(stopId) <= numberOfStops) {
      try {
        return await emtService.getStopInfo(stopId);
      } on DioError {
        rethrow;
      }
    }
  }

  Future getNumberOfStops() async {
    try {
      return await emtService.getNumberOfStops();
    } on DioError {
      rethrow;
    }
  }

  List<List<Arrive>> groupArrivesByLine(List<Arrive> arrives) {
    arrives.sort((a, b) => a.line.compareTo(b.line));

    List<List<Arrive>> orderedArrives = [];

    for (int i = 0; i < arrives.length;) {
      List<Arrive> lineArrives = [];
      lineArrives.add(arrives[i++]);
      lineArrives.add(arrives[i++]);
      lineArrives.sort((a, b) => a.estimateArrive.compareTo(b.estimateArrive));
      orderedArrives.add(lineArrives);
    }

    orderedArrives.sort(
        (a, b) => a.first.estimateArrive.compareTo(b.first.estimateArrive));

    return orderedArrives;
  }
}
