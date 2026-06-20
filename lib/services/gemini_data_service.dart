import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/app_config.dart';
import '../models/coffee_shop.dart';
import '../models/place_coffee_shop.dart';
import 'package:uuid/uuid.dart';

void _log(String message) {
  if (kDebugMode) debugPrint(message);
}

class GeminiDataService {
  static final GeminiDataService instance = GeminiDataService._init();
  GenerativeModel? _model;

  GeminiDataService._init() {
    _initializeModel();
  }

  void _initializeModel() {
    final apiKey = AppConfig.geminiApiKey;
    _log('🔑 Gemini API key configured: ${apiKey.isNotEmpty}');

    if (apiKey.isNotEmpty && !apiKey.contains('your_gemini_api_key_here')) {
      try {
        _model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: apiKey,
        );
        _log('✅ Gemini model initialized successfully with gemini-2.5-flash');
      } catch (e) {
        _log('❌ Failed to initialize Gemini: $e');
      }
    } else {
      _log('❌ Gemini API Key tidak valid atau belum diset');
    }
  }

  /// Memanggil Gemini AI untuk generate rekomendasi kedai kopi berdasarkan kota.
  Future<List<CoffeeShop>> generateCoffeeShopsForLocation(
      String location) async {
    _log('🤖 Starting Gemini generation for location: $location');

    // Coba re-initialize kalau sebelumnya gagal (misal user baru masukin API key)
    if (_model == null) {
      _log('⚠️ Model not initialized, attempting to re-initialize...');
      _initializeModel();
    }

    if (_model == null) {
      _log('❌ Model still null after re-initialization');
      throw Exception(
          'API Key Gemini belum diatur atau tidak valid. Gunakan --dart-define=GEMINI_API_KEY=... atau .env saat debug.');
    }

    final prompt = '''
Anda adalah asisten data. Tugas Anda adalah memberikan 3-5 kedai kopi populer dan nyata di lokasi berikut: "$location".
Untuk setiap kedai kopi, berikan titik perkiraan lokasi (latitude dan longitude yang mendekati asli).
Berikan juga 3 menu andalan (bisa kopi atau non-kopi).

KEMBALIKAN HANYA ARRAY JSON TANPA TEKS LAIN. CONTOH FORMAT:
[
  {
    "name": "Nama Kedai",
    "address": "Alamat Lengkap",
    "latitude": -6.2088,
    "longitude": 106.8456,
    "rating": 4.5,
    "vibes": ["Nugas", "Nongkrong"],
    "menu": [
      {
        "name": "Iced Americano",
        "price": 25000,
        "category": "Coffee",
        "temperature": "Iced",
        "strengthLevel": 4,
        "sweetnessLevel": 1,
        "flavorTags": ["Nutty"],
        "milkTypes": ["No Milk"]
      }
    ]
  }
]

ATURAN SANGAT PENTING (STRICT ENUM):
1. 'vibes' HANYA BOLEH berisi: "Nugas", "Nongkrong", "Aesthetic", "Date", "Meeting". Jangan gunakan kata lain.
2. 'category' HANYA BOLEH: "Coffee", "Non-Coffee", "Tea", "Pastry".
3. 'temperature' HANYA BOLEH: "Hot", "Iced", "Both".
4. 'flavorTags' HANYA BOLEH: "Chocolate", "Fruity", "Nutty", "Caramel", "Floral", "Vanilla".
5. 'milkTypes' HANYA BOLEH: "Regular", "Oat Milk", "Almond Milk", "Soy Milk", "No Milk".
6. 'strengthLevel' dan 'sweetnessLevel' adalah integer 1 sampai 5.
7. 'price' harus berupa angka bulat realistis dalam Rupiah (contoh: 25000).
8. 'latitude' dan 'longitude' wajib diisi berupa angka desimal untuk area tersebut.
Tolong HANYA output JSON array yang valid.
''';

    try {
      _log('📤 Sending request to Gemini...');
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      _log('📥 Received response from Gemini');
      var responseText = response.text ?? '[]';
      _log('📄 Raw response length: ${responseText.length} characters');

      // Bersihkan teks (kadang AI merespon dengan ```json ... ```)
      responseText =
          responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      _log('🧹 Cleaned response length: ${responseText.length} characters');

      final List<dynamic> jsonList = jsonDecode(responseText);
      _log('✅ JSON parsed successfully, ${jsonList.length} shops found');

      final uuid = const Uuid();

      List<CoffeeShop> shops = [];
      for (var shopJson in jsonList) {
        final shopId = uuid.v4();

        List<MenuItem> menuItems = [];
        if (shopJson['menu'] != null) {
          for (var itemJson in shopJson['menu']) {
            menuItems.add(MenuItem(
              id: uuid.v4(),
              shopId: shopId,
              name: itemJson['name'] ?? 'Menu Baru',
              price: itemJson['price'] ?? 20000,
              category: itemJson['category'] ?? 'Coffee',
              temperature: itemJson['temperature'] ?? 'Both',
              strengthLevel: itemJson['strengthLevel'] ?? 3,
              sweetnessLevel: itemJson['sweetnessLevel'] ?? 3,
              flavorTags: List<String>.from(itemJson['flavorTags'] ?? []),
              milkTypes: List<String>.from(itemJson['milkTypes'] ?? []),
              description: '',
              imageUrl: '',
            ));
          }
        }

        final shopName = shopJson['name'] ?? 'Kedai Kopi';
        _log('  ✓ Shop: $shopName (${menuItems.length} menu items)');

        shops.add(CoffeeShop(
          id: shopId,
          name: shopName,
          address: shopJson['address'] ?? location,
          imageUrl:
              'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&auto=format&fit=crop&q=60', // Placeholder
          rating: (shopJson['rating'] ?? 4.0).toDouble(),
          latitude: shopJson['latitude'] != null
              ? (shopJson['latitude'] as num).toDouble()
              : null,
          longitude: shopJson['longitude'] != null
              ? (shopJson['longitude'] as num).toDouble()
              : null,
          vibes: List<String>.from(shopJson['vibes'] ?? []),
          menu: menuItems,
        ));
      }

      _log(
          '🎉 Successfully generated ${shops.length} coffee shops with total ${shops.fold(0, (sum, s) => sum + s.menu.length)} menu items');
      return shops;
    } catch (e) {
      _log('❌ Error during generation: $e');
      throw Exception('Gagal men-generate data dari Gemini: $e');
    }
  }

  /// Hybrid method: Enrich real place data with vibes and menu using Gemini.
  Future<List<CoffeeShop>> enrichPlaceData(
      List<PlaceCoffeeShop> placeShops) async {
    _log(
        '🤖 Starting Gemini enrichment for ${placeShops.length} real coffee shops');

    // Coba re-initialize kalau sebelumnya gagal
    if (_model == null) {
      _log('⚠️ Model not initialized, attempting to re-initialize...');
      _initializeModel();
    }

    if (_model == null) {
      _log('❌ Model still null after re-initialization');
      throw Exception(
          'API Key Gemini belum diatur atau tidak valid. Gunakan --dart-define=GEMINI_API_KEY=... atau .env saat debug.');
    }

    // Build the input data for Gemini
    final shopDataJson =
        jsonEncode(placeShops.map((shop) => shop.toJson()).toList());

    final prompt = '''
Anda adalah asisten data. Berikut adalah daftar kedai kopi NYATA dari provider places dengan nama, alamat, dan koordinat GPS yang akurat:
$shopDataJson

Tugas Anda HANYA melengkapi data ini dengan:
1. Vibes (maksimal 2-3 per kedai)
2. 3 menu andalan yang bervariasi dan terasa lokal (bisa kopi atau non-kopi)
3. Rating (realistis 3.0 - 5.0)

JANGAN membuat kedai baru, JANGAN mengganti nama kedai, JANGAN mengganti alamat, dan JANGAN mengganti koordinat.

KEMBALIKAN HANYA ARRAY JSON TANPA TEKS LAIN. CONTOH FORMAT:
[
  {
    "name": "Nama Kedai (SAMA PERSIS dengan input)",
    "address": "Alamat Lengkap (SAMA PERSIS dengan input)",
    "latitude": -6.2088,
    "longitude": 106.8456,
    "rating": 4.5,
    "vibes": ["Nugas", "Nongkrong"],
    "menu": [
      {
        "name": "Iced Americano",
        "price": 25000,
        "category": "Coffee",
        "temperature": "Iced",
        "strengthLevel": 4,
        "sweetnessLevel": 1,
        "flavorTags": ["Nutty"],
        "milkTypes": ["No Milk"]
      }
    ]
  }
]

ATURAN SANGAT PENTING (STRICT ENUM):
1. 'vibes' HANYA BOLEH berisi: "Nugas", "Nongkrong", "Aesthetic", "Date", "Meeting". Jangan gunakan kata lain.
2. 'category' HANYA BOLEH: "Coffee", "Non-Coffee", "Tea", "Pastry".
3. 'temperature' HANYA BOLEH: "Hot", "Iced", "Both".
4. 'flavorTags' HANYA BOLEH: "Chocolate", "Fruity", "Nutty", "Caramel", "Floral", "Vanilla".
5. 'milkTypes' HANYA BOLEH: "Regular", "Oat Milk", "Almond Milk", "Soy Milk", "No Milk".
6. 'strengthLevel' dan 'sweetnessLevel' adalah integer 1 sampai 5.
7. 'price' harus berupa angka bulat realistis dalam Rupiah (contoh: 25000).
8. PERTAHANKAN nama, alamat, latitude, dan longitude SAMA PERSIS dengan input.
9. Buat menu lebih variatif; jangan selalu memakai nama menu generik yang sama untuk semua kedai.
Tolong HANYA output JSON array yang valid dengan jumlah item SAMA dengan input dan urutan SAMA dengan input.
''';

    try {
      _log('📤 Sending enrichment request to Gemini...');
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      _log('📥 Received enrichment response from Gemini');
      var responseText = response.text ?? '[]';
      _log('📄 Raw response length: ${responseText.length} characters');

      // Bersihkan teks
      responseText =
          responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      _log('🧹 Cleaned response length: ${responseText.length} characters');

      final List<dynamic> jsonList = jsonDecode(responseText);
      _log('✅ JSON parsed successfully, ${jsonList.length} shops enriched');

      final uuid = const Uuid();

      final shops = <CoffeeShop>[];
      final itemCount = jsonList.length < placeShops.length
          ? jsonList.length
          : placeShops.length;
      for (var index = 0; index < itemCount; index++) {
        final shopJson = jsonList[index];
        final sourceShop = placeShops[index];
        final shopId = uuid.v4();

        final menuItems = <MenuItem>[];
        if (shopJson['menu'] != null) {
          for (var itemJson in shopJson['menu']) {
            menuItems.add(MenuItem(
              id: uuid.v4(),
              shopId: shopId,
              name: itemJson['name'] ?? 'Menu Baru',
              price: itemJson['price'] ?? 20000,
              category: itemJson['category'] ?? 'Coffee',
              temperature: itemJson['temperature'] ?? 'Both',
              strengthLevel: itemJson['strengthLevel'] ?? 3,
              sweetnessLevel: itemJson['sweetnessLevel'] ?? 3,
              flavorTags: List<String>.from(itemJson['flavorTags'] ?? []),
              milkTypes: List<String>.from(itemJson['milkTypes'] ?? []),
              description: '',
              imageUrl: '',
            ));
          }
        }

        _log(
            '  ✓ Enriched Shop: ${sourceShop.name} (${menuItems.length} menu items)');

        shops.add(CoffeeShop(
          id: shopId,
          name: sourceShop.name,
          address: sourceShop.address,
          imageUrl:
              'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&auto=format&fit=crop&q=60',
          rating: (shopJson['rating'] ?? 4.0).toDouble(),
          latitude: sourceShop.latitude,
          longitude: sourceShop.longitude,
          vibes: List<String>.from(shopJson['vibes'] ?? []),
          menu: menuItems,
        ));
      }

      _log(
          '🎉 Successfully enriched ${shops.length} coffee shops with total ${shops.fold(0, (sum, s) => sum + s.menu.length)} menu items');
      return shops;
    } catch (e) {
      _log('❌ Error during enrichment: $e');
      throw Exception('Gagal men-enrich data dari Gemini: $e');
    }
  }
}
