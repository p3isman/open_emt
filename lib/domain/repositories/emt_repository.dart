import 'package:dio/dio.dart';
import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/data/services/emt_service.dart';
import 'package:open_emt/utils/utils.dart';

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

    stopId = stopId.trim();
    if (stopId != '' &&
        isNumeric(stopId) &&
        int.parse(stopId) > 0 &&
        int.parse(stopId) <= numberOfStops) {
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

    for (int i = 0; i < arrives.length / 2;) {
      List<Arrive> lineArrives = [];
      lineArrives.add(arrives[i++]);
      lineArrives.add(arrives[i++]);
      lineArrives.sort((a, b) => a.estimateArrive.compareTo(b.estimateArrive));
      orderedArrives.add(lineArrives);
    }

    return orderedArrives;
  }
}
