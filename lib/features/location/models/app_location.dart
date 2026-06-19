class AppLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String source; // 'gps', 'network', 'manual', 'ip'

  const AppLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.source,
  });

  factory AppLocation.empty() {
    return const AppLocation(
      latitude: 0.0,
      longitude: 0.0,
      address: 'Lokasi tidak diketahui',
      source: 'unknown',
    );
  }

  bool get isEmpty => latitude == 0.0 && longitude == 0.0;
}
