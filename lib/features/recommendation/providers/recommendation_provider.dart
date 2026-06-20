import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/coffee_shop.dart';
import '../../../services/foursquare_places_service.dart';
import '../../../services/gemini_data_service.dart';
import '../../../helpers/database_helper.dart';

void _log(String message) {
  if (kDebugMode) debugPrint(message);
}

String _normalizeShopText(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
}

bool _isKnownShopName(String name) {
  final normalized = _normalizeShopText(name);
  return normalized.isNotEmpty &&
      normalized != 'unknown' &&
      normalized != 'unknown coffee' &&
      normalized != 'unknown coffee shop' &&
      normalized != 'kedai kopi' &&
      normalized != 'coffee shop';
}

bool _hasNearbyCoordinates(CoffeeShop a, CoffeeShop b) {
  if (a.latitude == null ||
      a.longitude == null ||
      b.latitude == null ||
      b.longitude == null) {
    return false;
  }

  final distance = Geolocator.distanceBetween(
    a.latitude!,
    a.longitude!,
    b.latitude!,
    b.longitude!,
  );
  return distance <= 75;
}

bool _isDuplicateShop(CoffeeShop a, CoffeeShop b) {
  final nameA = _normalizeShopText(a.name);
  final nameB = _normalizeShopText(b.name);
  final addressA = _normalizeShopText(a.address);
  final addressB = _normalizeShopText(b.address);

  if (nameA.isEmpty || nameB.isEmpty) return false;
  if (nameA == nameB && addressA == addressB) return true;
  return nameA == nameB && _hasNearbyCoordinates(a, b);
}

int _findDuplicateShopIndex(List<CoffeeShop> shops, CoffeeShop shop) {
  return shops.indexWhere(
      (existing) => existing.id == shop.id || _isDuplicateShop(existing, shop));
}

CoffeeShop _copyShopWithId(CoffeeShop shop, String id) {
  return CoffeeShop(
    id: id,
    name: shop.name,
    address: shop.address,
    menu: shop.menu
        .map(
          (item) => MenuItem(
            id: item.id,
            shopId: id,
            name: item.name,
            category: item.category,
            description: item.description,
            price: item.price,
            temperature: item.temperature,
            strengthLevel: item.strengthLevel,
            sweetnessLevel: item.sweetnessLevel,
            milkTypes: item.milkTypes,
            flavorTags: item.flavorTags,
            caffeineLevel: item.caffeineLevel,
            dietaryTags: item.dietaryTags,
            imageUrl: item.imageUrl,
            isActive: item.isActive,
            updatedAt: item.updatedAt,
          ),
        )
        .toList(),
    vibes: shop.vibes,
    imageUrl: shop.imageUrl,
    rating: shop.rating,
    latitude: shop.latitude,
    longitude: shop.longitude,
  );
}

List<CoffeeShop> _mergeUniqueShops(List<CoffeeShop> shops) {
  final merged = <CoffeeShop>[];
  for (final shop in shops) {
    final duplicateIndex = _findDuplicateShopIndex(merged, shop);
    if (duplicateIndex >= 0) {
      merged[duplicateIndex] = _copyShopWithId(shop, merged[duplicateIndex].id);
    } else {
      merged.add(shop);
    }
  }
  return merged;
}

class RecommendationState {
  final List<CoffeeShop> allShops;
  final bool isLoading;

  RecommendationState({
    required this.allShops,
    required this.isLoading,
  });

  RecommendationState copyWith({
    List<CoffeeShop>? allShops,
    bool? isLoading,
  }) {
    return RecommendationState(
      allShops: allShops ?? this.allShops,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RecommendationResult {
  final CoffeeShop shop;
  final MenuItem item;
  final double matchScore; // 0.0 to 1.0

  RecommendationResult(
      {required this.shop, required this.item, required this.matchScore});
}

class RecommendationNotifier extends StateNotifier<RecommendationState> {
  RecommendationNotifier()
      : super(RecommendationState(allShops: [], isLoading: true)) {
    loadShops();
  }

  Future<void> loadShops() async {
    _log('DEBUG: loadShops() started');
    state = state.copyWith(isLoading: true);

    try {
      // 1. Load from local SQLite
      List<CoffeeShop> localShops = [];
      try {
        localShops = await DatabaseHelper.instance.getAllCoffeeShops();
        _log('DEBUG: Loaded ${localShops.length} shops from SQLite');
      } catch (e) {
        _log('DEBUG Error loading local shops: $e');
      }

      // 2. Load from Supabase
      List<CoffeeShop> supabaseShops = [];
      try {
        final response = await Supabase.instance.client
            .from('coffeeshops')
            .select('*, menu_items(*)');

        _log('DEBUG: Supabase response length: ${response.length}');
        for (var shopMap in response) {
          final menuList = shopMap['menu_items'] as List<dynamic>? ?? [];
          final menu =
              menuList.map((m) => MenuItem.fromSupabaseMap(m)).toList();
          supabaseShops.add(CoffeeShop.fromSupabaseMap(shopMap, menu));
        }
        _log('DEBUG: Loaded ${supabaseShops.length} shops from Supabase');
      } catch (e) {
        _log('DEBUG Warning: Failed to load shops from Supabase: $e');
      }

      // Supabase overrides local if duplicated by ID/name/address/coordinates.
      // Ignore previous bad rows such as "Unknown Coffee Shop" so they do not
      // appear in search results even if they already exist in local/Supabase.
      final validShops = [...localShops, ...supabaseShops]
          .where((shop) => _isKnownShopName(shop.name))
          .toList();
      final mergedShops = _mergeUniqueShops(validShops);

      _log('DEBUG: Total merged unique shops: ${mergedShops.length}');
      state = state.copyWith(allShops: mergedShops, isLoading: false);
    } catch (e) {
      _log('DEBUG Fatal error loading shops: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addCoffeeShop(CoffeeShop shop) async {
    _log('DEBUG: addCoffeeShop() started for ${shop.name}');

    if (!_isKnownShopName(shop.name)) {
      _log('DEBUG: Skipping coffee shop with unknown name');
      return;
    }

    // 1. Optimistic UI Update: update existing duplicate instead of adding another copy.
    final currentShops = state.allShops.toList();
    final index = _findDuplicateShopIndex(currentShops, shop);
    final shopToSave =
        index >= 0 ? _copyShopWithId(shop, currentShops[index].id) : shop;
    if (index >= 0) {
      currentShops[index] = shopToSave;
    } else {
      currentShops.add(shopToSave);
    }
    state = state.copyWith(allShops: currentShops);

    // 2. Save to Local SQLite (Always succeeds locally, might fail on Web)
    try {
      await DatabaseHelper.instance.insertCoffeeShop(shopToSave);
      _log('DEBUG: Successfully saved ${shopToSave.name} to SQLite');
    } catch (e) {
      _log('DEBUG Error saving to local DB: $e');
    }

    // 3. Try saving to Supabase (Might fail due to RLS or Offline)
    try {
      await Supabase.instance.client
          .from('coffeeshops')
          .upsert(shopToSave.toSupabaseMap());

      if (shopToSave.menu.isNotEmpty) {
        final menuMaps = shopToSave.menu
            .map((item) => item.toSupabaseMap(parentShopId: shopToSave.id))
            .toList();
        await Supabase.instance.client.from('menu_items').upsert(menuMaps);
      }
      _log('DEBUG: Successfully saved ${shopToSave.name} to Supabase');
    } catch (e) {
      _log('DEBUG Warning: Could not save shop to Supabase: $e');
    }
  }

  Future<void> deleteCoffeeShop(String id) async {
    // 1. Optimistic UI Update
    final currentShops = state.allShops.where((s) => s.id != id).toList();
    state = state.copyWith(allShops: currentShops);

    // 2. Local delete
    try {
      await DatabaseHelper.instance.deleteCoffeeShop(id);
    } catch (e) {
      _log('Error deleting local shop: $e');
    }

    // 3. Supabase delete
    try {
      await Supabase.instance.client.from('coffeeshops').delete().eq('id', id);
    } catch (e) {
      _log('Error deleting shop from Supabase: $e');
    }
  }

  Future<void> trainDataWithGemini(String location) async {
    // Keep this method for backward compatibility, but prefer real places from
    // Foursquare and use Gemini only to enrich menu/vibes.
    await trainDataWithHybrid(location);
  }

  /// Hybrid method: Use Foursquare for real locations + Gemini for vibes/menu
  Future<void> trainDataWithHybrid(String location) async {
    state = state.copyWith(isLoading: true);
    try {
      _log('🚀 Starting hybrid search for: $location');

      // 1. Fetch real coffee shops from Foursquare Places API
      final foursquareShops =
          await FoursquarePlacesService.instance.searchCoffeeShops(location);
      _log('✅ Foursquare returned ${foursquareShops.length} real coffee shops');

      if (foursquareShops.isEmpty) {
        throw Exception(
            'Tidak ada kedai kopi nyata yang ditemukan untuk lokasi ini. Coba area yang lebih spesifik.');
      }

      // 2. Enrich with vibes and menu using Gemini
      final enrichedShops = _mergeUniqueShops(
        await GeminiDataService.instance.enrichMaptilerData(foursquareShops),
      );
      _log('✅ Gemini enriched ${enrichedShops.length} unique coffee shops');

      // 3. Simpan ke Supabase/SQLite. addCoffeeShop also deduplicates existing state.
      for (var shop in enrichedShops) {
        await addCoffeeShop(shop);
      }

      state = state.copyWith(
        allShops: _mergeUniqueShops(state.allShops),
        isLoading: false,
      );
      _log('🎉 Hybrid search completed successfully');
    } catch (e) {
      _log('DEBUG: Error in trainDataWithHybrid: $e');
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  List<CoffeeShop> searchShops({
    required int budget,
    String? vibe,
    double? userLat,
    double? userLng,
  }) {
    // 1. Filter by budget
    var validShops = state.allShops.where((shop) {
      return shop.menu.any((item) => item.price <= budget);
    }).toList();

    // 2. Hard filter by vibe (if selected)
    if (vibe != null && vibe.isNotEmpty) {
      validShops = validShops.where((shop) {
        return shop.vibes.any((v) =>
            v.toLowerCase().contains(vibe.toLowerCase()) ||
            vibe.toLowerCase().contains(v.toLowerCase()));
      }).toList();
    }

    // 3. Sort by distance (if GPS available)
    if (userLat != null && userLng != null) {
      validShops.sort((a, b) {
        if (a.latitude == null || a.longitude == null) {
          return 1; // Put at bottom
        }
        if (b.latitude == null || b.longitude == null) {
          return -1;
        }

        final distA = Geolocator.distanceBetween(
            userLat, userLng, a.latitude!, a.longitude!);
        final distB = Geolocator.distanceBetween(
            userLat, userLng, b.latitude!, b.longitude!);

        return distA.compareTo(distB);
      });
    }

    return validShops;
  }

  List<RecommendationResult> searchGuided({
    required String drinkType,
    required String flavor,
    required String temperature,
    required int strength,
    required String milkType,
    required int sweetness,
    required String vibe,
    required double budget,
    required bool openNow,
  }) {
    List<RecommendationResult> results = [];

    for (var shop in state.allShops) {
      // Vibe Check (Soft Filter now, adds to score)
      final lowerVibes = shop.vibes.map((v) => v.toLowerCase()).toList();
      bool hasVibe = lowerVibes.any((v) =>
          v.contains(vibe.toLowerCase()) || vibe.toLowerCase().contains(v));

      for (var item in shop.menu) {
        // Hard filter: Budget
        if (item.price > budget) continue;

        // Category Check (More robust)
        final itemCat = item.category.toLowerCase();
        final searchCat = drinkType.toLowerCase();
        bool categoryMatch =
            itemCat.contains(searchCat) || searchCat.contains(itemCat);
        if (searchCat == 'coffee' && itemCat == 'kopi') categoryMatch = true;
        if (searchCat == 'kopi' && itemCat == 'coffee') categoryMatch = true;

        // If it's a completely different category, skip it, but be forgiving
        if (!categoryMatch && itemCat.isNotEmpty) {
          // allow if we're just scoring loosely, but usually category is a hard filter
          // Let's keep it as hard filter but with the relaxed conditions above
          continue;
        }

        // Calculate Match Score
        double score = 0.0;
        int maxFactors = 0;

        if (hasVibe) {
          score += 1.0;
        }
        maxFactors++;

        // Temperature Match
        maxFactors++;
        if (item.temperature.toLowerCase() == temperature.toLowerCase() ||
            item.temperature.toLowerCase() == 'both' ||
            temperature.toLowerCase() == 'both') {
          score += 1.0;
        }

        // Milk Type Match
        if (drinkType == 'Coffee' || drinkType == 'Non-Coffee') {
          maxFactors++;
          final lowerMilks =
              item.milkTypes.map((m) => m.toLowerCase()).toList();
          if (lowerMilks.any((m) =>
              m.contains(milkType.toLowerCase()) ||
              milkType.toLowerCase().contains(m))) {
            score += 1.0;
          }
        }

        // Flavor Match
        maxFactors++;
        final lowerFlavors =
            item.flavorTags.map((f) => f.toLowerCase()).toList();
        if (lowerFlavors.any((f) =>
            f.contains(flavor.toLowerCase()) ||
            flavor.toLowerCase().contains(f))) {
          score += 1.0;
        }

        // Strength Match
        maxFactors++;
        double strengthDiff = (item.strengthLevel - strength).abs().toDouble();
        score += (1.0 -
            (strengthDiff / 4.0)); // closer to 0 difference = higher score

        // Sweetness Match
        maxFactors++;
        double sweetnessDiff =
            (item.sweetnessLevel - sweetness).abs().toDouble();
        score += (1.0 - (sweetnessDiff / 4.0));

        double finalScore = score / maxFactors;

        // Add to results as long as it fits the budget and category
        // We lower the threshold to 0.1 so we almost always recommend something if data exists
        if (finalScore >= 0.1) {
          results.add(RecommendationResult(
              shop: shop, item: item, matchScore: finalScore));
        }
      }
    }

    // Sort by highest match score
    results.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return results;
  }
}

final recommendationProvider =
    StateNotifierProvider<RecommendationNotifier, RecommendationState>((ref) {
  return RecommendationNotifier();
});
