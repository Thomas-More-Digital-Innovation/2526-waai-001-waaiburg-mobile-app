class AvatarConfiguration {
  final int bodyType;
  final int shirtId;
  final int pantsId;
  final int hairId;
  final int? accessoryId;
  final String skinColor;
  final String shirtColor;
  final String pantsColor;
  final String hairColor;

  const AvatarConfiguration({
    this.bodyType = 0,
    this.shirtId = 0,
    this.pantsId = 0,
    this.hairId = 0,
    this.accessoryId,
    this.skinColor = '#FFD7B5', // Default skin color
    this.shirtColor = '#4A90E2', // Default blue shirt
    this.pantsColor = '#2C3E50', // Default dark pants
    this.hairColor = '#5D4037', // Default brown hair
  });

  factory AvatarConfiguration.fromJson(Map<String, dynamic> json) {
    return AvatarConfiguration(
      bodyType: json['bodyType'] ?? 0,
      shirtId: json['shirtId'] ?? 0,
      pantsId: json['pantsId'] ?? 0,
      hairId: json['hairId'] ?? 0,
      accessoryId: json['accessoryId'],
      skinColor: json['skinColor'] ?? '#FFD7B5',
      shirtColor: json['shirtColor'] ?? '#4A90E2',
      pantsColor: json['pantsColor'] ?? '#2C3E50',
      hairColor: json['hairColor'] ?? '#5D4037',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyType': bodyType,
      'shirtId': shirtId,
      'pantsId': pantsId,
      'hairId': hairId,
      'accessoryId': accessoryId,
      'skinColor': skinColor,
      'shirtColor': shirtColor,
      'pantsColor': pantsColor,
      'hairColor': hairColor,
    };
  }

  AvatarConfiguration copyWith({
    int? bodyType,
    int? shirtId,
    int? pantsId,
    int? hairId,
    int? accessoryId,
    String? skinColor,
    String? shirtColor,
    String? pantsColor,
    String? hairColor,
  }) {
    return AvatarConfiguration(
      bodyType: bodyType ?? this.bodyType,
      shirtId: shirtId ?? this.shirtId,
      pantsId: pantsId ?? this.pantsId,
      hairId: hairId ?? this.hairId,
      accessoryId: accessoryId ?? this.accessoryId,
      skinColor: skinColor ?? this.skinColor,
      shirtColor: shirtColor ?? this.shirtColor,
      pantsColor: pantsColor ?? this.pantsColor,
      hairColor: hairColor ?? this.hairColor,
    );
  }

  @override
  String toString() {
    return 'AvatarConfiguration(bodyType: $bodyType, shirtId: $shirtId, pantsId: $pantsId, hairId: $hairId)';
  }
}
