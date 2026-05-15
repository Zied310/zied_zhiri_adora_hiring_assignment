import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zied_zhiri_adora_hiring_assignment/core/services/background_service.dart';
import 'package:zied_zhiri_adora_hiring_assignment/core/services/location_service.dart';
import 'package:zied_zhiri_adora_hiring_assignment/core/services/notification_service.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationService _locationService = LocationService();
  final BackgroundService _backgroundService = BackgroundService();
  Position? _position;

  bool _loading = false;
  bool _isRunningInBackground = false;
  String? _error;

  Future<void> _requestNotificationPermission() async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  }

  Future<void> _startBackgroundService() async {
    if(_isRunningInBackground) return;
    _backgroundService.startBackgroundService();
    setState(() {
      _isRunningInBackground = true;
    });
  }

  void _stopBackgroundService() {
    _backgroundService.stopBackgroundService();
    setState(() {
      _isRunningInBackground = false;
    });
  }

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final pos = await _locationService.getCurrentLocation();

      if (pos == null) {
        setState(() {
          _error = "Permission denied or location unavailable";
        });
      } else {
        setState(() {
          _position = pos;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to get location";
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await _requestNotificationPermission();
      await NotificationService.initialize();
      await _backgroundService.initializeService();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _getLocation,
              child: Text(_loading ? "Loading..." : "Get Current Location"),
            ),

            const SizedBox(height: 20),

            if (_position != null)
              Text(
                "Latitude: ${_position!.latitude}\nLongitude: ${_position!.longitude}",
              ),

            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 40),
            if (_isRunningInBackground)
              ElevatedButton(
                onPressed: _stopBackgroundService,
                child: const Text("Stop Background Service"),
              )
            else
              ElevatedButton(
                onPressed: _startBackgroundService,
                child: const Text("Start Background Service"),
              ),
            const SizedBox(height: 20),

            Text(
              _isRunningInBackground ? "Tracking ACTIVE" : "Tracking STOPPED",
              style: TextStyle(
                color: _isRunningInBackground ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}