import 'package:location/location.dart';
import 'package:open_emt/data/services/location_service.dart';

class LocationRepository {
  final LocationService locationService;

  LocationRepository({required this.locationService});

  Future<LocationData?> getLocation() async {
    return await locationService.getLocation();
  }
}
