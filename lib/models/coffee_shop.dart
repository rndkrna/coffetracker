import 'dart:convert';

class CoffeeShop {
  final String id;
  final String name;
  final String address;
  final List<MenuItem> menu;
  final List<String> vibes; // ['nongki', 'ngechill', 'nugas']
  final String imageUrl;
  final double rating;
  final double? latitude;
  final double? longitude;

  CoffeeShop({
    required this.id,
    required this.name,
    required this.address,
    required this.menu,
    required this.vibes,
    required this.imageUrl,
    required this.rating,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'vibes': jsonEncode(vibes),
      'imageUrl': imageUrl,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory CoffeeShop.fromMap(Map<String, dynamic> map, List<MenuItem> menu) {
    return CoffeeShop(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      vibes: List<String>.from(jsonDecode(map['vibes'])),
      imageUrl: map['imageUrl'],
      rating: map['rating'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      menu: menu,
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'vibes': vibes, // Supabase handles List<String> directly
      'image_url': imageUrl,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) return List<String>.from(decoded);
      } catch (_) {}
      return [value]; // Fallback
    }
    if (value is List) {
      return List<String>.from(value.map((e) => e.toString()));
    }
    return [];
  }

  factory CoffeeShop.fromSupabaseMap(Map<String, dynamic> map, List<MenuItem> menu) {
    return CoffeeShop(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      vibes: _parseStringList(map['vibes']),
      imageUrl: map['image_url'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      menu: menu,
    );
  }
}

class MenuItem {
  final String id;
  final String shopId;
  final String name;
  final String category; // e.g. Coffee, Non-Coffee, Pastry
  final String description;
  final int price;
  final String temperature; // Hot, Cold, Both
  final int strengthLevel; // 1-5 (1: very light, 5: very strong)
  final int sweetnessLevel; // 1-5
  final List<String> milkTypes; // e.g. ['Oat', 'Almond', 'Soy', 'Regular']
  final List<String> flavorTags; // e.g. ['Fruity', 'Nutty', 'Chocolate']
  final String caffeineLevel; // High, Medium, Low, None
  final List<String> dietaryTags; // e.g. ['Vegan', 'Gluten-Free']
  final String imageUrl;
  final bool isActive;
  final DateTime updatedAt;

  MenuItem({
    this.id = '',
    this.shopId = '',
    required this.name,
    this.category = 'Coffee',
    this.description = '',
    required this.price,
    this.temperature = 'Both',
    this.strengthLevel = 3,
    this.sweetnessLevel = 3,
    this.milkTypes = const ['Regular'],
    this.flavorTags = const [],
    this.caffeineLevel = 'Medium',
    this.dietaryTags = const [],
    this.imageUrl = '',
    this.isActive = true,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap({String? parentShopId}) {
    return {
      'id': id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : id,
      'shopId': parentShopId ?? shopId,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'temperature': temperature,
      'strengthLevel': strengthLevel,
      'sweetnessLevel': sweetnessLevel,
      'milkTypes': jsonEncode(milkTypes),
      'flavorTags': jsonEncode(flavorTags),
      'caffeineLevel': caffeineLevel,
      'dietaryTags': jsonEncode(dietaryTags),
      'imageUrl': imageUrl,
      'isActive': isActive ? 1 : 0,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id']?.toString() ?? '',
      shopId: map['shopId']?.toString() ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'Coffee',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      temperature: map['temperature'] ?? 'Both',
      strengthLevel: map['strengthLevel'] ?? 3,
      sweetnessLevel: map['sweetnessLevel'] ?? 3,
      milkTypes: CoffeeShop._parseStringList(map['milkTypes']),
      flavorTags: CoffeeShop._parseStringList(map['flavorTags']),
      caffeineLevel: map['caffeineLevel'] ?? 'Medium',
      dietaryTags: CoffeeShop._parseStringList(map['dietaryTags']),
      imageUrl: map['imageUrl'] ?? '',
      isActive: map['isActive'] == 1,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now() : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabaseMap({String? parentShopId}) {
    return {
      'id': id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : id,
      'coffeeshop_id': parentShopId ?? shopId,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'temperature': temperature,
      'strength_level': strengthLevel,
      'sweetness_level': sweetnessLevel,
      'milk_types': milkTypes,
      'flavor_tags': flavorTags,
      'caffeine_level': caffeineLevel,
      'dietary_tags': dietaryTags,
      'image_url': imageUrl,
      'is_active': isActive,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory MenuItem.fromSupabaseMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id']?.toString() ?? '',
      shopId: map['coffeeshop_id']?.toString() ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'Coffee',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toInt(),
      temperature: map['temperature'] ?? 'Both',
      strengthLevel: map['strength_level'] ?? 3,
      sweetnessLevel: map['sweetness_level'] ?? 3,
      milkTypes: CoffeeShop._parseStringList(map['milk_types']),
      flavorTags: CoffeeShop._parseStringList(map['flavor_tags']),
      caffeineLevel: map['caffeine_level'] ?? 'Medium',
      dietaryTags: CoffeeShop._parseStringList(map['dietary_tags']),
      imageUrl: map['image_url'] ?? '',
      isActive: map['is_active'] ?? true,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at']) ?? DateTime.now() : DateTime.now(),
    );
  }
}
