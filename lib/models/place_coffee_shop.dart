class PlaceCoffeeShop {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? placeId;

  PlaceCoffeeShop({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.placeId,
  });

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
