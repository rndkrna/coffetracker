import 'package:coffee_budget_tracker/services/maptiler_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MaptilerService', () {
    test('buildNearbySearchUri uses provided coordinates and default radius', () {
      final uri = MaptilerService.buildNearbySearchUri(
        apiKey: 'test-key',
        latitude: -6.2,
        longitude: 106.8,
      );

      expect(
        uri.toString(),
        'https://api.maptiler.com/search/coffee.json?key=test-key&prox=106.8,-6.2,5000&limit=10',
      );
    });
  });
}
