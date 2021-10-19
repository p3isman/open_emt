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
}
