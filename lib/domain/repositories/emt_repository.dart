import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/data/services/emt_service.dart';

class EMTRepository {
  final EMTService emtService;

  EMTRepository({required this.emtService});

  Future<StopModel> getStopInfo(String stopId) async {
    return await emtService.getStopInfo(stopId);
  }
}
