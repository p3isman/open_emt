import 'package:open_emt/data/models/stop_list_model.dart';
import 'package:open_emt/data/models/stop_model.dart';

abstract class IEMTRepository {
  Future<StopModel?> getStopInfo(String stopId) async {}

  Future getNumberOfStops() async {}

  Future<StopListModel?> getStopList() async {}

  List<List<Arrive>>? groupArrivesByLine(List<Arrive> arrives) {}
}
