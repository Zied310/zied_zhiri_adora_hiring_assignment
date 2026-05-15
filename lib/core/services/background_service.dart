import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zied_zhiri_adora_hiring_assignment/core/services/notification_service.dart';

// Runs in a separate background isolate
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  Timer? timer;
  
  service.on("stop").listen((event) {
    timer?.cancel();
    service.stopSelf();
    print("background service stopped");
  });

  service.on("start").listen((event) {
    print("background service started");
  });

  timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (position != null) {
        final lat = position.latitude;
        final lng = position.longitude;

        print("Latitude: $lat, Longitude: $lng");

        await NotificationService.showNotification(
          lat: lat,
          lng: lng,
        );
      } else {
        print("Location unavailable");
      }
    } catch (e) {
      print("Location error: $e");
    }
  });
}

class BackgroundService {
  final service = FlutterBackgroundService();
  void startBackgroundService() {
    service.startService();
  }

  void stopBackgroundService() {
    service.invoke("stop");
  }

  Future<void> initializeService() async {
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false, //Only start from button press, not on app launch
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        onStart: onStart,
        // Foreground service required for persistent background tracking on Android
        isForegroundMode: true,
        autoStartOnBoot: false,
      ),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  
}
