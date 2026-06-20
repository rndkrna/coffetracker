import 'package:coffee_budget_tracker/services/foursquare_places_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FoursquarePlacesService', () {
    test('buildNearbySearchUri uses coordinates and default radius', () {
      final uri = FoursquarePlacesService.buildNearbySearchUri(
        latitude: -6.2,
        longitude: 106.8,
      );

      expect(uri.scheme, 'https');
      expect(uri.host, 'api.foursquare.com');
      expect(uri.path, '/v3/places/search');
      expect(uri.queryParameters['ll'], '-6.2,106.8');
      expect(uri.queryParameters['radius'], '5000');
      expect(uri.queryParameters['categories'], '13032,13034');
      expect(uri.queryParameters['sort'], 'DISTANCE');
    });

    test('buildTextSearchUri uses provided location', () {
      final uri = FoursquarePlacesService.buildTextSearchUri(
        location: 'Jakarta',
      );

      expect(uri.scheme, 'https');
      expect(uri.host, 'api.foursquare.com');
      expect(uri.path, '/v3/places/search');
      expect(uri.queryParameters['near'], 'Jakarta');
      expect(uri.queryParameters['categories'], '13032,13034');
      expect(uri.queryParameters['sort'], 'RELEVANCE');
    });
  });
}
