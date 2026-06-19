import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/database_helper.dart';
import '../models/transaction.dart';

class SyncService {
  static final SyncService instance = SyncService._init();

  SyncService._init();

  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Synchronize all local transactions to Supabase for the current user.
  ///
  /// Current strategy:
  /// - Local changes are upserted to remote.
  /// - Remote rows missing locally are downloaded.
  ///
  /// Delete sync and conflict resolution require local metadata such as
  /// `updatedAt`, `deletedAt`, and `syncStatus`; those are not present in the
  /// current local model yet.
  Future<void> syncTransactions() async {
    final supabase = _supabase;
    if (supabase == null) return;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final localTransactions =
          await DatabaseHelper.instance.getAllTransactions();
      final localIds = localTransactions.map((tx) => tx.id).toSet();

      final toUpsert = localTransactions.map((tx) {
        return {
          'id': tx.id,
          'user_id': user.id,
          'coffee_name': tx.coffeeName,
          'price': tx.price,
          'transaction_date': tx.date.toIso8601String().split('T')[0],
          'transaction_time': _timeOnly(tx.transactionTime),
          'category': tx.category,
          'note': tx.note,
          'location': tx.location,
          'location_lat': tx.locationLat,
          'location_lng': tx.locationLng,
          'location_source': tx.locationSource?.name,
          'coffeeshop_id': tx.coffeeshopId,
          'source': tx.source.name,
          'created_at': tx.createdAt.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      if (toUpsert.isNotEmpty) {
        await supabase.from('transactions').upsert(toUpsert);
      }

      final allRemote =
          await supabase.from('transactions').select().eq('user_id', user.id);

      for (final data in allRemote) {
        final id = data['id']?.toString();
        if (id == null || id.isEmpty || localIds.contains(id)) continue;

        final tx = CoffeeTransaction(
          id: id,
          coffeeName: data['coffee_name'] ?? '',
          price: (data['price'] as num?)?.toInt() ?? 0,
          date: DateTime.parse(data['transaction_date']),
          category: data['category'] ?? 'Lainnya',
          note: data['note'],
          location: data['location'],
          locationLat: (data['location_lat'] as num?)?.toDouble(),
          locationLng: (data['location_lng'] as num?)?.toDouble(),
          locationSource: _locationSourceFromName(data['location_source']),
          coffeeshopId: data['coffeeshop_id'],
          source: _transactionSourceFromName(data['source']),
          createdAt:
              DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
          transactionTime: _parseTransactionTime(
            data['transaction_date'],
            data['transaction_time'],
          ),
        );
        await DatabaseHelper.instance.insertTransaction(tx);
      }

      debugPrint('Sync transactions completed successfully');
    } catch (e) {
      debugPrint('Error syncing transactions: $e');
    }
  }

  /// Synchronize Coffeeshops and Menu Items to Supabase Catalog.
  Future<void> syncCatalog() async {
    final supabase = _supabase;
    if (supabase == null) return;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final localShops = await DatabaseHelper.instance.getAllCoffeeShops();

      final shopsToUpsert = <Map<String, dynamic>>[];
      final menusToUpsert = <Map<String, dynamic>>[];

      for (final shop in localShops) {
        shopsToUpsert.add({
          'id': shop.id,
          'name': shop.name,
          'address': shop.address,
          'image_url': shop.imageUrl,
          'rating': shop.rating,
          'vibes': shop.vibes,
          'latitude': shop.latitude,
          'longitude': shop.longitude,
        });

        for (final menu in shop.menu) {
          menusToUpsert.add({
            'id': menu.id,
            'coffeeshop_id': shop.id,
            'name': menu.name,
            'price': menu.price,
            'category': menu.category,
            'description': menu.description,
            'temperature': menu.temperature,
            'strength_level': menu.strengthLevel,
            'sweetness_level': menu.sweetnessLevel,
            'milk_types': menu.milkTypes,
            'flavor_tags': menu.flavorTags,
            'caffeine_level': menu.caffeineLevel,
            'dietary_tags': menu.dietaryTags,
            'image_url': menu.imageUrl,
            'is_active': menu.isActive,
            'updated_at': menu.updatedAt.toIso8601String(),
          });
        }
      }

      if (shopsToUpsert.isNotEmpty) {
        await supabase.from('coffeeshops').upsert(shopsToUpsert);
      }
      if (menusToUpsert.isNotEmpty) {
        await supabase.from('menu_items').upsert(menusToUpsert);
      }

      debugPrint('Sync catalog completed successfully');
    } catch (e) {
      debugPrint('Error syncing catalog: $e');
    }
  }

  /// Perform a full sync.
  Future<void> syncAll() async {
    await syncTransactions();
    await syncCatalog();
  }

  String _timeOnly(DateTime dateTime) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}';
  }

  DateTime _parseTransactionTime(dynamic date, dynamic time) {
    final parsedDate =
        DateTime.tryParse(date?.toString() ?? '') ?? DateTime.now();
    final timeParts = time?.toString().split(':') ?? const [];
    if (timeParts.length < 2) return parsedDate;

    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts[1]) ?? 0;
    final second = timeParts.length > 2 ? int.tryParse(timeParts[2]) ?? 0 : 0;

    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      hour,
      minute,
      second,
    );
  }

  LocationSource? _locationSourceFromName(dynamic value) {
    if (value == null) return null;
    return LocationSource.values.firstWhere(
      (source) => source.name == value,
      orElse: () => LocationSource.manual,
    );
  }

  TransactionSource _transactionSourceFromName(dynamic value) {
    if (value == null) return TransactionSource.manual;
    return TransactionSource.values.firstWhere(
      (source) => source.name == value,
      orElse: () => TransactionSource.manual,
    );
  }
}
