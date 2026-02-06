class Stop {
  final String id;
  final String tourId;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final int order;
  final DateTime createdAt;
  final bool isAudioEnabled;
  final String? audioUrl;
  final bool isHotelAvailable;
  final bool has4g;
  final bool has5g;
  final String? signalStrength;

  Stop({
    required this.id,
    required this.tourId,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.order,
    required this.createdAt,
    this.isAudioEnabled = false,
    this.audioUrl,
    this.isHotelAvailable = false,
    this.has4g = false,
    this.has5g = false,
    this.signalStrength,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'] as String,
      tourId: json['tour_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      isAudioEnabled: json['is_audio_enabled'] as bool? ?? false,
      audioUrl: json['audio_url'] as String?,
      isHotelAvailable: json['is_hotel_available'] as bool? ?? false,
      has4g: json['has_4g'] as bool? ?? false,
      has5g: json['has_5g'] as bool? ?? false,
      signalStrength: json['signal_strength'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tour_id': tourId,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'is_audio_enabled': isAudioEnabled,
      'audio_url': audioUrl,
      'is_hotel_available': isHotelAvailable,
      'has_4g': has4g,
      'has_5g': has5g,
      'signal_strength': signalStrength,
    };
  }
}
