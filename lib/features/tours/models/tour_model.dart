class Tour {
  final String id;
  final String title;
  final String description;
  final int cityId;
  final int visitors;
  final double distance;
  final double latitude;
  final double longitude;

  Tour({
    required this.id,
    required this.title,
    required this.description,
    required this.cityId,
    required this.visitors,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cityId: json['city_id'] as int,
      visitors: json['visitors'] as int,
      distance: (json['distance'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
