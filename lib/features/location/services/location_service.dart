import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/app_location.dart';

class LocationService {
  static final LocationService instance = LocationService._internal();
  LocationService._internal();

  /// Gets current location with fallback strategies.
  /// Tier 1: High accuracy GPS
  /// Tier 2: Low accuracy / Last known position
  /// Tier 3: Manual (handled by UI state if everything fails)
  Future<AppLocation> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _getFallbackLocation('Service dinonaktifkan');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _getFallbackLocation('Izin ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _getFallbackLocation('Izin ditolak permanen');
    }

    try {
      // Tier 1: Try high accuracy
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );
      
      return await _buildAppLocation(position, 'gps');
    } catch (e) {
      // Tier 2: Try last known or low accuracy
      try {
        Position? lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          return await _buildAppLocation(lastKnown, 'network');
        }

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 5),
          ),
        );
        return await _buildAppLocation(position, 'network');
      } catch (e2) {
        return _getFallbackLocation('Gagal mendapatkan lokasi');
      }
    }
  }

  Future<AppLocation> _buildAppLocation(Position position, String source) async {
    String addressText = 'Lokasi tidak diketahui';
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        addressText = '${place.locality}, ${place.subAdministrativeArea}';
        // Cleanup formatting
        addressText = addressText.replaceAll(RegExp(r'^,\s*'), '').trim();
        if (addressText.isEmpty) {
          addressText = '${place.name}';
        }
      }
    } catch (e) {
      // Failed to geocode, keep default addressText
    }

    return AppLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      address: addressText,
      source: source,
    );
  }

  AppLocation _getFallbackLocation(String reason) {
    return AppLocation(
      latitude: 0.0,
      longitude: 0.0,
      address: reason,
      source: 'error',
    );
  }
}
