class Cinema {
  final String id;
  final String name;
  final String brand;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String openHours;

  const Cinema({
    required this.id,
    required this.name,
    required this.brand,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.openHours = '10.00 - 22.00',
  });

  List<double> get coordinates => [longitude, latitude];
}
