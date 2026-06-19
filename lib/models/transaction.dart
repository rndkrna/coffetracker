class CoffeeTransaction {
  final String id;
  final String coffeeName;
  final int price;
  final DateTime date;
  final String? location;
  final String? note;
  final String category;
  final DateTime createdAt;

  // Extended fields (Tahap 2)
  final double? locationLat;
  final double? locationLng;
  final LocationSource? locationSource;
  final String? coffeeshopId;
  final TransactionSource source;
  final DateTime transactionTime;

  CoffeeTransaction({
    required this.id,
    required this.coffeeName,
    required this.price,
    required this.date,
    this.location,
    this.note,
    this.category = 'Lainnya',
    DateTime? createdAt,
    this.locationLat,
    this.locationLng,
    this.locationSource,
    this.coffeeshopId,
    this.source = TransactionSource.manual,
    DateTime? transactionTime,
  })  : createdAt = createdAt ?? DateTime.now(),
        transactionTime = transactionTime ?? date;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coffeeName': coffeeName,
      'price': price,
      'date': date.toIso8601String(),
      'location': location,
      'note': note,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'locationLat': locationLat,
      'locationLng': locationLng,
      'locationSource': locationSource?.name,
      'coffeeshopId': coffeeshopId,
      'source': source.name,
      'transactionTime': transactionTime.toIso8601String(),
    };
  }

  factory CoffeeTransaction.fromMap(Map<String, dynamic> map) {
    return CoffeeTransaction(
      id: map['id'],
      coffeeName: map['coffeeName'],
      price: map['price'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      note: map['note'],
      category: map['category'] ?? 'Lainnya',
      createdAt: DateTime.parse(map['createdAt']),
      locationLat: map['locationLat'] != null ? (map['locationLat'] as num).toDouble() : null,
      locationLng: map['locationLng'] != null ? (map['locationLng'] as num).toDouble() : null,
      locationSource: map['locationSource'] != null
          ? LocationSource.values.firstWhere(
              (e) => e.name == map['locationSource'],
              orElse: () => LocationSource.manual,
            )
          : null,
      coffeeshopId: map['coffeeshopId'],
      source: map['source'] != null
          ? TransactionSource.values.firstWhere(
              (e) => e.name == map['source'],
              orElse: () => TransactionSource.manual,
            )
          : TransactionSource.manual,
      transactionTime: map['transactionTime'] != null
          ? DateTime.parse(map['transactionTime'])
          : DateTime.parse(map['date']),
    );
  }
}

enum LocationSource { gps, network, ip, manual }

enum TransactionSource { manual, ocr }
