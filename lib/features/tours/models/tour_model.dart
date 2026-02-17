class Tour {
  final String id;
  final String title;
  final String description;
  final String cityName;
  final String stateName;
  final String imageUrl;
  final double distance;
  final int stops;
  final int visitors;
  final double latitude;
  final double longitude;

  Tour({
    required this.id,
    required this.title,
    required this.description,
    required this.cityName,
    required this.stateName,
    required this.imageUrl,
    required this.distance,
    required this.stops,
    required this.visitors,
    required this.latitude,
    required this.longitude,
  });

  Tour copyWith({
    String? id,
    String? title,
    String? description,
    String? cityName,
    String? stateName,
    String? imageUrl,
    double? distance,
    int? stops,
    int? visitors,
    double? latitude,
    double? longitude,
  }) {
    return Tour(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cityName: cityName ?? this.cityName,
      stateName: stateName ?? this.stateName,
      imageUrl: imageUrl ?? this.imageUrl,
      distance: distance ?? this.distance,
      stops: stops ?? this.stops,
      visitors: visitors ?? this.visitors,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'] as String,

      title: json['title'] as String,
      description: json['description'] as String,
      cityName: json['city']['name'] as String,
      stateName: json['city']['state']['name'] as String,
      imageUrl: json['tour_images']['image_url'] as String,
      distance: (json['distance'] as num).toDouble(),
      stops: json['stop'][0]['count'] as int,
      visitors: json['visitors'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
