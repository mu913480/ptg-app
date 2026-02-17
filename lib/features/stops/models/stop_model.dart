class Stop {
  final int id;
  final String name;
  final String tourId;
  final String description;
  final double latitude;
  final double longitude;
  final String image;

  Stop({
    required this.id,
    required this.name,
    required this.tourId,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.image,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    final stopImages = json['stop_images'] as List?;
    String firstImage = '';
    if (stopImages != null && stopImages.isNotEmpty) {
      firstImage = stopImages[0]['image_url'] as String? ?? '';
    }

    return Stop(
      id: json['id'] as int,
      name: json['name'] as String,
      tourId: json['tour_id'] as String,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      image: firstImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tour_id': tourId,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'image': image,
    };
  }
}
