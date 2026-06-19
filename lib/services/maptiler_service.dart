import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/app_config.dart';

void _log(String message) {
  if (kDebugMode) debugPrint(message);
}

String _normalizePlaceText(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
}

String? _readString(Map<String, dynamic> map, List<String> path) {
  dynamic current = map;
  for (final key in path) {
    if (current is! Map<String, dynamic> || !current.containsKey(key)) {
      return null;
    }
    current = current[key];
  }

  if (current is String && current.trim().isNotEmpty) {
    return current.trim();
  }
  return null;
}

bool _isKnownShopName(String name) {
  final normalized = _normalizePlaceText(name);
  return normalized.isNotEmpty &&
      normalized != 'unknown' &&
      normalized != 'unknown coffee' &&
      normalized != 'unknown coffee shop' &&
      normalized != 'kedai kopi' &&
      normalized != 'coffee shop';
}

String _dedupKey(MaptilerCoffeeShop shop) {
  final name = _normalizePlaceText(shop.name);
  final address = _normalizePlaceText(shop.address);
  final latBucket = (shop.latitude * 1000).round();
  final lngBucket = (shop.longitude * 1000).round();
  return '$name|$address|$latBucket|$lngBucket';
}

List<MaptilerCoffeeShop> _deduplicateShops(List<MaptilerCoffeeShop> shops) {
  final seen = <String>{};
  final result = <MaptilerCoffeeShop>[];

  for (final shop in shops) {
    if (!_isKnownShopName(shop.name)) {
      _log('  ⚠️ Skipping unnamed MapTiler shop');
      continue;
    }

    final key = _dedupKey(shop);
    if (seen.add(key)) {
      result.add(shop);
    }
  }

  return result;
}

/// Model for raw MapTiler POI data
class MaptilerCoffeeShop {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? placeId;

  MaptilerCoffeeShop({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.placeId,
  });

  factory MaptilerCoffeeShop.fromJson(Map<String, dynamic> json) {
    final name = _readString(json, ['properties', 'name']) ??
        _readString(json, ['properties', 'display_name']) ??
        _readString(json, ['properties', 'poi', 'name']) ??
        _readString(json, ['text']) ??
        _readString(json, ['place_name']) ??
        _readString(json, ['matching_text']) ??
        '';

    final address = _readString(json, ['properties', 'address']) ??
        _readString(json, ['properties', 'place_formatted']) ??
        _readString(json, ['properties', 'formatted']) ??
        _readString(json, ['place_name']) ??
        '';

    final coordinates = json['geometry']?['coordinates'] as List<dynamic>;

    return MaptilerCoffeeShop(
      name: name,
      address: address,
      latitude: (coordinates[1] as num).toDouble(),
      longitude: (coordinates[0] as num).toDouble(),
      placeId:
          _readString(json, ['properties', 'id']) ?? _readString(json, ['id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
    };
  }
}

class MaptilerService {
  static final MaptilerService instance = MaptilerService._init();
  String? _apiKey;

  MaptilerService._init() {
    _initializeApiKey();
  }

  void _initializeApiKey() {
    _apiKey = AppConfig.maptilerApiKey;
    _log('🔑 MapTiler API key configured: ${_apiKey?.isNotEmpty ?? false}');
  }

  static Uri buildGeocodingSearchUri({
    required String apiKey,
    required String location,
  }) {
    final query = Uri.encodeComponent('coffee shop $location');
    return Uri.parse(
      'https://api.maptiler.com/geocoding/$query.json?key=$apiKey&limit=10&types=place,poi',
    );
  }

  static Uri buildNearbySearchUri({
    required String apiKey,
    required double latitude,
    required double longitude,
    int radius = 5000,
  }) {
    return Uri.parse(
      'https://api.maptiler.com/search/coffee.json?key=$apiKey&prox=$longitude,$latitude,$radius&limit=10',
    );
  }

  /// Search for coffee shops in a specific location using MapTiler Geocoding API
  Future<List<MaptilerCoffeeShop>> searchCoffeeShops(String location) async {
    _log('🗺️ Starting MapTiler search for location: $location');

    // Re-initialize API key if needed
    if (_apiKey == null || _apiKey!.isEmpty) {
      _initializeApiKey();
    }

    if (_apiKey == null ||
        _apiKey!.isEmpty ||
        _apiKey!.contains('your-maptiler-api-key')) {
      throw Exception(
          'API Key MapTiler belum diatur atau tidak valid. Gunakan --dart-define=MAPTILER_API_KEY=... atau .env saat debug.');
    }

    try {
      // MapTiler Geocoding API endpoint
      // Using 'coffee' as the query to search for coffee shops
      final apiKey = _apiKey!;
      final url = buildGeocodingSearchUri(apiKey: apiKey, location: location);

      _log('📤 Sending request to MapTiler API');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _log('📥 Received response from MapTiler');
        final data = jsonDecode(response.body);

        final features = data['features'] as List<dynamic>? ?? [];
        _log('✅ Found ${features.length} coffee shops from MapTiler');

        List<MaptilerCoffeeShop> shops = [];
        for (var feature in features) {
          try {
            final shop = MaptilerCoffeeShop.fromJson(feature);
            shops.add(shop);
            _log(
                '  ✓ Shop: ${shop.name} at (${shop.latitude}, ${shop.longitude})');
          } catch (e) {
            _log('  ⚠️ Error parsing shop: $e');
          }
        }

        final dedupedShops = _deduplicateShops(shops);
        _log('✅ ${dedupedShops.length} unique coffee shops after dedup');
        return dedupedShops;
      } else {
        _log('❌ MapTiler API returned status ${response.statusCode}');
        throw Exception(
            'MapTiler API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _log('❌ Error during MapTiler search: $e');
      throw Exception('Gagal mencari kedai kopi dari MapTiler: $e');
    }
  }

  /// Alternative method using MapTiler Search API for more precise POI search
  Future<List<MaptilerCoffeeShop>> searchCoffeeShopsByCoordinates(
      double latitude, double longitude,
      [int radius = 5000] // 5km radius
      ) async {
    _log(
        '🗺️ Starting MapTiler search by coordinates: ($latitude, $longitude)');

    if (_apiKey == null || _apiKey!.isEmpty) {
      _initializeApiKey();
    }

    if (_apiKey == null ||
        _apiKey!.isEmpty ||
        _apiKey!.contains('your-maptiler-api-key')) {
      throw Exception(
          'API Key MapTiler belum diatur atau tidak valid. Gunakan --dart-define=MAPTILER_API_KEY=... atau .env saat debug.');
    }

    try {
      // Using MapTiler Search API for nearby places
      final apiKey = _apiKey!;
      final url = buildNearbySearchUri(
        apiKey: apiKey,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );

      _log('📤 Sending request to MapTiler Search API');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _log('📥 Received response from MapTiler Search');
        final data = jsonDecode(response.body);

        final features = data['features'] as List<dynamic>? ?? [];
        _log('✅ Found ${features.length} coffee shops nearby');

        List<MaptilerCoffeeShop> shops = [];
        for (var feature in features) {
          try {
            final shop = MaptilerCoffeeShop.fromJson(feature);
            shops.add(shop);
            _log('  ✓ Shop: ${shop.name}');
          } catch (e) {
            _log('  ⚠️ Error parsing shop: $e');
          }
        }

        final dedupedShops = _deduplicateShops(shops);
        _log('✅ ${dedupedShops.length} unique coffee shops nearby after dedup');
        return dedupedShops;
      } else {
        _log('❌ MapTiler Search API returned status ${response.statusCode}');
        throw Exception('MapTiler Search API error: ${response.statusCode}');
      }
    } catch (e) {
      _log('❌ Error during MapTiler search by coordinates: $e');
      throw Exception('Gagal mencari kedai kopi dari MapTiler: $e');
    }
  }
}
