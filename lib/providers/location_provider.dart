import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocode/geocode.dart' as geo;
import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  String? _currentAddress;
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;

  String? get currentAddress => _currentAddress;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get error => _error;

  LocationProvider() {
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('last_lat');
    final lng = prefs.getDouble('last_lng');
    final addr = prefs.getString('last_address');

    if (lat != null && lng != null) {
      _currentPosition = Position(
        longitude: lng,
        latitude: lat,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
    if (addr != null) {
      _currentAddress = addr;
    }
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // 1. Check Service
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      // 2. Check Permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      // 3. Get Position
      debugPrint("Step 3: Getting Position...");

      // Optimization 1: Try to get the last known position first (Instant)
      debugPrint("Attempting Last Known Position...");
      Position? position = await Geolocator.getLastKnownPosition();
      debugPrint("Last Known Position: $position");

      // Optimization 2: If no last known position, request current position
      if (position == null) {
        debugPrint("Requesting Current Position (might take time)...");

        // Android Emulator Fix: Force usage of Android Location Manager
        LocationSettings locationSettings;
        if (defaultTargetPlatform == TargetPlatform.android) {
          locationSettings = AndroidSettings(
            accuracy: LocationAccuracy.medium,
            distanceFilter: 100,
            forceLocationManager: true,
            timeLimit: const Duration(seconds: 5), // Reduced from 15s
          );
        } else {
          locationSettings = const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5), // Reduced from 15s
          );
        }

        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings,
          );
        } catch (e) {
          debugPrint("High accuracy failed ($e). Trying low accuracy...");
          // Fallback to low accuracy
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 5),
          );
        }
      }

      debugPrint("Position Obtained: $position");
      _currentPosition = position;

      // 4. Get Address (Reverse Geocoding)
      debugPrint("Step 4: Geocoding...");
      try {
        // Use geocoding package's placemarkFromCoordinates
        // convert to list of Placemark
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 3)); // Reduced from 5s

        debugPrint("Geocoding success, found ${placemarks.length} placemarks");

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          // Construct readable address
          final List<String> parts = [];
          // street, locality (city), country
          if (place.street != null && place.street!.isNotEmpty) {
            parts.add(place.street!);
          }
          if (place.locality != null && place.locality!.isNotEmpty) {
            parts.add(place.locality!);
          }
          if (place.country != null && place.country!.isNotEmpty) {
            parts.add(place.country!);
          }

          _currentAddress = parts.isNotEmpty
              ? parts.join(', ')
              : "Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}";
        } else {
          _currentAddress =
              "Address Unavailable\nLat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}";
        }
      } catch (e) {
        debugPrint("Geocoding failed: $e");
        _currentAddress =
            "Address Unavailable (Check Net)\nLat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}";
      }

      // 5. Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_lat', position.latitude);
      await prefs.setDouble('last_lng', position.longitude);
      await prefs.setString('last_address', _currentAddress!);
    } on TimeoutException catch (_) {
      _error = 'Location request timed out. Please try again.';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
