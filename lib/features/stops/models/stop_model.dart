class Stop {
  final int id;
  final String name;
  final String tourId;
  final String description;
  final String image;

  Stop({
    required this.id,
    required this.name,
    required this.tourId,
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
      description: json['description'] as String? ?? '',
      image: firstImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tour_id': tourId,
      'description': description,
      'image': image,
    };
  }
}
