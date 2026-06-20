import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../models/place_coffee_shop.dart';

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
      normalized != 'coffee shop' &&
      normalized != 'coffee';
}

String _dedupKey(PlaceCoffeeShop shop) {
  final name = _normalizePlaceText(shop.name);
  final address = _normalizePlaceText(shop.address);
  final latBucket = (shop.latitude * 1000).round();
  final lngBucket = (shop.longitude * 1000).round();
  return '$name|$address|$latBucket|$lngBucket';
}

List<PlaceCoffeeShop> _deduplicateShops(List<PlaceCoffeeShop> shops) {
  final seen = <String>{};
  final result = <PlaceCoffeeShop>[];

  for (final shop in shops) {
    if (!_isKnownShopName(shop.name)) {
      _log('  ⚠️ Skipping unnamed Foursquare place');
      continue;
    }

    final key = _dedupKey(shop);
    if (seen.add(key)) {
      result.add(shop);
    }
  }

  return result;
}

class FoursquarePlacesService {
  static final FoursquarePlacesService instance =
      FoursquarePlacesService._init();

  String? _apiKey;

  FoursquarePlacesService._init() {
    _initializeApiKey();
  }

  void _initializeApiKey() {
    _apiKey = AppConfig.foursquareApiKey;
    _log('🔑 Foursquare API key configured: ${_apiKey?.isNotEmpty ?? false}');
  }

  static Uri buildTextSearchUri({
    required String location,
    int limit = 15,
  }) {
    return Uri.https('api.foursquare.com', '/v3/places/search', {
      'query': 'coffee cafe kedai kopi',
      'near': location,
      'categories': '13032,13034',
      'limit': limit.toString(),
      'sort': 'RELEVANCE',
      'fields': 'fsq_id,name,location,geocodes,categories,distance',
    });
  }

  static Uri buildNearbySearchUri({
    required double latitude,
    required double longitude,
    int radius = 5000,
    int limit = 15,
  }) {
    return Uri.https('api.foursquare.com', '/v3/places/search', {
      'query': 'coffee cafe kedai kopi',
      'll': '$latitude,$longitude',
      'radius': radius.toString(),
      'categories': '13032,13034',
      'limit': limit.toString(),
      'sort': 'DISTANCE',
      'fields': 'fsq_id,name,location,geocodes,categories,distance',
    });
  }

  Future<List<PlaceCoffeeShop>> searchCoffeeShops(String location) async {
    _log('📍 Starting Foursquare search for location: $location');

    if (_apiKey == null || _apiKey!.isEmpty) {
      _initializeApiKey();
    }

    if (_apiKey == null ||
        _apiKey!.isEmpty ||
        _apiKey!.contains('your-foursquare-api-key')) {
      throw Exception(
        'API Key Foursquare belum diatur atau tidak valid. Gunakan --dart-define=FOURSQUARE_API_KEY=... atau .env saat debug.',
      );
    }

    final url = buildTextSearchUri(location: location);
    return _search(url, 'Foursquare text search');
  }

  Future<List<PlaceCoffeeShop>> searchCoffeeShopsByCoordinates(
    double latitude,
    double longitude, [
    int radius = 5000,
  ]) async {
    _log('📍 Starting Foursquare nearby search: ($latitude, $longitude)');

    if (_apiKey == null || _apiKey!.isEmpty) {
      _initializeApiKey();
    }

    if (_apiKey == null ||
        _apiKey!.isEmpty ||
        _apiKey!.contains('your-foursquare-api-key')) {
      throw Exception(
        'API Key Foursquare belum diatur atau tidak valid. Gunakan --dart-define=FOURSQUARE_API_KEY=... atau .env saat debug.',
      );
    }

    final url = buildNearbySearchUri(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
    return _search(url, 'Foursquare nearby search');
  }

  Future<List<PlaceCoffeeShop>> _search(Uri url, String label) async {
    try {
      _log('📤 Sending request to $label');
      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey!,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        _log('❌ Foursquare API returned status ${response.statusCode}');
        throw Exception('Foursquare API error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      _log('✅ Found ${results.length} places from Foursquare');

      final shops = <PlaceCoffeeShop>[];
      for (final result in results) {
        try {
          if (result is! Map<String, dynamic>) continue;
          final shop = _fromFoursquarePlace(result);
          shops.add(shop);
          _log('  ✓ Shop: ${shop.name}');
        } catch (e) {
          _log('  ⚠️ Error parsing Foursquare place: $e');
        }
      }

      final deduped = _deduplicateShops(shops);
      _log('✅ ${deduped.length} unique Foursquare coffee shops after dedup');
      return deduped;
    } catch (e) {
      _log('❌ Error during Foursquare search: $e');
      throw Exception('Gagal mencari kedai kopi dari Foursquare: $e');
    }
  }

  PlaceCoffeeShop _fromFoursquarePlace(Map<String, dynamic> place) {
    final name = _readString(place, ['name']) ?? '';
    final address = _readString(place, ['location', 'formatted_address']) ??
        _readString(place, ['location', 'address']) ??
        _readString(place, ['location', 'locality']) ??
        '';

    final geocodes = place['geocodes'] as Map<String, dynamic>?;
    final main = geocodes?['main'] as Map<String, dynamic>?;
    final roof = geocodes?['roof'] as Map<String, dynamic>?;
    final coordinates = main ?? roof;

    if (coordinates == null ||
        coordinates['latitude'] == null ||
        coordinates['longitude'] == null) {
      throw Exception('Missing Foursquare coordinates');
    }

    return PlaceCoffeeShop(
      name: name,
      address: address,
      latitude: (coordinates['latitude'] as num).toDouble(),
      longitude: (coordinates['longitude'] as num).toDouble(),
      placeId: _readString(place, ['fsq_id']),
    );
  }
}
