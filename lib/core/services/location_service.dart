import 'package:geolocator/geolocator.dart';
import 'package:zied_zhiri_adora_hiring_assignment/core/permissions/location_permission.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    final bool isGranted = await LocationPermision().checkAndRequestPermission();
    if (!isGranted) return null;
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }
}