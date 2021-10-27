import 'package:geolocator/geolocator.dart';
import 'package:open_emt/data/services/location_service.dart';

class LocationRepository {
  final LocationService locationService;

  LocationRepository({required this.locationService});

  Future<Position> getCurrentPosition() async {
    return await locationService.getCurrentPosition();
  }
}
