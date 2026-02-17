class AvatarConfiguration {
  final String gender; // 'male' or 'female'
  final int bodyType;
  final int shirtId;
  final int pantsId;
  final int shoesId;
  final String skinColor;
  final String shirtColor;
  final String pantsColor;
  final String shoesColor;

  const AvatarConfiguration({
    this.gender = 'male',
    this.bodyType = 0,
    this.shirtId = 0,
    this.pantsId = 0,
    this.shoesId = 0,
    this.skinColor = '#FFD7B5', // Default skin color
    this.shirtColor = '#4A90E2', // Default blue shirt
    this.pantsColor = '#2C3E50', // Default dark pants
    this.shoesColor = '#000000', // Default black shoes
  });

  factory AvatarConfiguration.fromJson(Map<String, dynamic> json) {
    return AvatarConfiguration(
      gender: json['gender'] ?? 'male',
      bodyType: json['bodyType'] ?? 0,
      shirtId: json['shirtId'] ?? 0,
      pantsId: json['pantsId'] ?? 0,
      shoesId: json['shoesId'] ?? 0,
      skinColor: json['skinColor'] ?? '#FFD7B5',
      shirtColor: json['shirtColor'] ?? '#4A90E2',
      pantsColor: json['pantsColor'] ?? '#2C3E50',
      shoesColor: json['shoesColor'] ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'bodyType': bodyType,
      'shirtId': shirtId,
      'pantsId': pantsId,
      'shoesId': shoesId,
      'skinColor': skinColor,
      'shirtColor': shirtColor,
      'pantsColor': pantsColor,
      'shoesColor': shoesColor,
    };
  }

  AvatarConfiguration copyWith({
    String? gender,
    int? bodyType,
    int? shirtId,
    int? pantsId,
    int? shoesId,
    String? skinColor,
    String? shirtColor,
    String? pantsColor,
    String? shoesColor,
  }) {
    return AvatarConfiguration(
      gender: gender ?? this.gender,
      bodyType: bodyType ?? this.bodyType,
      shirtId: shirtId ?? this.shirtId,
      pantsId: pantsId ?? this.pantsId,
      shoesId: shoesId ?? this.shoesId,
      skinColor: skinColor ?? this.skinColor,
      shirtColor: shirtColor ?? this.shirtColor,
      pantsColor: pantsColor ?? this.pantsColor,
      shoesColor: shoesColor ?? this.shoesColor,
    );
  }

  @override
  String toString() {
    return 'AvatarConfiguration(bodyType: $bodyType, shirtId: $shirtId, pantsId: $pantsId)';
  }
}
