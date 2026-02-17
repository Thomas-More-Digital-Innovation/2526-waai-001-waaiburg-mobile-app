import 'package:flutter/material.dart';
import 'package:mobileapp/config/env.dart';
import 'package:mobileapp/model/avatar_configuration.dart';
import 'package:mobileapp/screens/avatar/utils/color_utils.dart';

class AvatarWidget extends StatelessWidget {
  final AvatarConfiguration config;
  final double size;
  final bool showBorder;

  const AvatarWidget({
    super.key,
    required this.config,
    this.size = 150,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBorder
          ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(size / 2),
            )
          : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Body (base) - at the back
          Positioned(
            top: -size * 0.13, // Move head up by 10%
            child: _buildBodyPart(
              'body',
              config.bodyType,
              ColorUtils.hexToColor(config.skinColor),
            ),
          ),
          // Shoes
          Positioned(
            top: size * 0.59, // Position at the bottom for feet
            left: size * 0.335, // Center horizontally
            child: SizedBox(
              width: size * 0.33, // Smaller width for shoes
              height: size * 0.33, // Smaller height for shoes
              child: _buildBodyPart(
                'shoes',
                config.shoesId,
                ColorUtils.hexToColor(config.shoesColor),
              ),
            ),
          ),
          // Pants
          Positioned(
            top: size * 0.56, // Verplaats naar beneden (35% van totale hoogte)
            left: size * 0.365, // Center horizontaal
            child: SizedBox(
              width: size * 0.28, // 70% van de originele breedte
              height: size * 0.28, // 70% van de originele hoogte
              child: _buildBodyPart(
                'pants',
                config.pantsId,
                ColorUtils.hexToColor(config.pantsColor),
              ),
            ),
          ),
          // Shirt
          Positioned(
            top: size * 0.31, // Verplaats naar beneden (35% van totale hoogte)
            left: size * 0.355, // Center horizontaal
            child: SizedBox(
              width: size * 0.3, // 70% van de originele breedte
              height: size * 0.3, // 70% van de originele hoogte
              child: _buildBodyPart(
                'shirt',
                config.shirtId,
                ColorUtils.hexToColor(config.shirtColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const Map<String, String> _directoryMap = {
    'body': 'bodies',
    'shirt': 'shirts',
    'pants': 'pants',
    'shoes': 'shoes',
  };

  Widget _buildBodyPart(String partType, int partId, Color color) {
    final directory = _directoryMap[partType] ?? partType;

    String fileName;
    if (partType == 'shirt' && partId >= 2) {
      // Gender-specific shirt
      fileName = '${partType}_${partId}_${config.gender}';
    } else if (partType == 'pants' && partId >= 2) {
      // Gender-specific pants
      fileName = '${partType}_${partId}_${config.gender}';
    } else {
      // Default naming
      fileName = '${partType}_$partId';
    }

    final assetPath = '$avatarPath/$directory/$fileName.png';

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      colorBlendMode: BlendMode.modulate,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return CustomPaint(
          size: Size(size, size),
          painter: AvatarPartPainter(
            partType: partType,
            partId: partId,
            color: color,
          ),
        );
      },
    );
  }
}

class AvatarPartPainter extends CustomPainter {
  final String partType;
  final int partId;
  final Color color;

  AvatarPartPainter({
    required this.partType,
    required this.partId,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    switch (partType) {
      case 'body':
        _drawBody(canvas, size, center, paint);
        break;
      case 'shirt':
        _drawShirt(canvas, size, center, paint, partId);
        break;
      case 'pants':
        _drawPants(canvas, size, center, paint, partId);
        break;
      case 'hair':
        _drawHair(canvas, size, center, paint, partId);
        break;
      case 'shoes':
        _drawShoes(canvas, size, center, paint, partId);
        break;
    }
  }

  void _drawBody(Canvas canvas, Size size, Offset center, Paint paint) {
    // Head
    canvas.drawCircle(
      Offset(center.dx, size.height * 0.35),
      size.width * 0.15,
      paint,
    );

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.6),
        width: size.width * 0.35,
        height: size.height * 0.3,
      ),
      const Radius.circular(15),
    );
    canvas.drawRRect(bodyRect, paint);

    // Arms
    _drawArm(canvas, size, center, paint, isLeft: true);
    _drawArm(canvas, size, center, paint, isLeft: false);

    // Eyes
    final eyePaint = Paint()..color = Colors.black;
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.06, size.height * 0.32),
      size.width * 0.02,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.06, size.height * 0.32),
      size.width * 0.02,
      eyePaint,
    );

    // Smile
    final smilePath = Path();
    smilePath.moveTo(center.dx - size.width * 0.08, size.height * 0.38);
    smilePath.quadraticBezierTo(
      center.dx,
      size.height * 0.42,
      center.dx + size.width * 0.08,
      size.height * 0.38,
    );
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawShirt(Canvas canvas, Size size, Offset center, Paint paint, int style) {
    if (style == 0) {
      // T-shirt
      final shirtRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, size.height * 0.6),
          width: size.width * 0.38,
          height: size.height * 0.32,
        ),
        const Radius.circular(15),
      );
      canvas.drawRRect(shirtRect, paint);
    } else if (style == 1) {
      // Long sleeve shirt
      final shirtRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, size.height * 0.6),
          width: size.width * 0.38,
          height: size.height * 0.32,
        ),
        const Radius.circular(15),
      );
      canvas.drawRRect(shirtRect, paint);

      // Sleeves
      _drawSleeve(canvas, size, center, paint, isLeft: true);
      _drawSleeve(canvas, size, center, paint, isLeft: false);
    }
  }

  void _drawPants(Canvas canvas, Size size, Offset center, Paint paint, int style) {
    if (style == 0) {
      // Long pants
      _drawLeg(canvas, size, center, paint, isLeft: true, length: 0.25);
      _drawLeg(canvas, size, center, paint, isLeft: false, length: 0.25);
    } else if (style == 1) {
      // Shorts
      _drawLeg(canvas, size, center, paint, isLeft: true, length: 0.15);
      _drawLeg(canvas, size, center, paint, isLeft: false, length: 0.15);
    }
  }

  void _drawHair(Canvas canvas, Size size, Offset center, Paint paint, int style) {
    if (style == 0) {
      // Short hair
      final hairPath = Path();
      hairPath.addArc(
        Rect.fromCircle(
          center: Offset(center.dx, size.height * 0.35),
          radius: size.width * 0.16,
        ),
        3.14,
        3.14,
      );
      canvas.drawPath(hairPath, paint);
    } else if (style == 1) {
      // Long hair
      final hairPath = Path();
      hairPath.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(center.dx, size.height * 0.32),
            width: size.width * 0.35,
            height: size.height * 0.25,
          ),
          const Radius.circular(20),
        ),
      );
      canvas.drawPath(hairPath, paint);
    } else if (style == 2) {
      // Bald
      // No hair drawn
    }
  }

  void _drawShoes(Canvas canvas, Size size, Offset center, Paint paint, int style) {
    if (style == 0) {
      // Sneakers
      // Left shoe
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            center.dx - size.width * 0.15,
            size.height * 0.95,
            size.width * 0.12,
            size.height * 0.05,
          ),
          const Radius.circular(5),
        ),
        paint,
      );
      // Right shoe
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            center.dx + size.width * 0.03,
            size.height * 0.95,
            size.width * 0.12,
            size.height * 0.05,
          ),
          const Radius.circular(5),
        ),
        paint,
      );
    } else if (style == 1) {
      // Boots
      // Left boot
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            center.dx - size.width * 0.15,
            size.height * 0.90,
            size.width * 0.12,
            size.height * 0.10,
          ),
          const Radius.circular(5),
        ),
        paint,
      );
      // Right boot
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            center.dx + size.width * 0.03,
            size.height * 0.90,
            size.width * 0.12,
            size.height * 0.10,
          ),
          const Radius.circular(5),
        ),
        paint,
      );
    }
  }

  void _drawArm(Canvas canvas, Size size, Offset center, Paint paint, {required bool isLeft}) {
    final xOffset = isLeft ? -0.3 : 0.2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          center.dx + size.width * xOffset,
          size.height * 0.5,
          size.width * 0.1,
          size.height * 0.25,
        ),
        const Radius.circular(8),
      ),
      paint,
    );
  }

  void _drawSleeve(Canvas canvas, Size size, Offset center, Paint paint, {required bool isLeft}) {
    final xOffset = isLeft ? -0.32 : 0.2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          center.dx + size.width * xOffset,
          size.height * 0.5,
          size.width * 0.12,
          size.height * 0.28,
        ),
        const Radius.circular(8),
      ),
      paint,
    );
  }

  void _drawLeg(Canvas canvas, Size size, Offset center, Paint paint, {required bool isLeft, required double length}) {
    final xOffset = isLeft ? -0.15 : 0.03;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          center.dx + size.width * xOffset,
          size.height * 0.72,
          size.width * 0.12,
          size.height * length,
        ),
        const Radius.circular(8),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(AvatarPartPainter oldDelegate) {
    return oldDelegate.partType != partType || oldDelegate.partId != partId || oldDelegate.color != color;
  }
}
