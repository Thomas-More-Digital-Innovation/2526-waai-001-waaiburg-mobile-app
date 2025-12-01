import 'package:mobileapp/model/sortable.dart';

class InfoSegment extends Sortable {
  @override
  final int? orderNumber;

  final int id;
  final int sectionId;
  final String title;
  final String? titleImage;
  final String? createdAt;
  final String? updatedAt;

  InfoSegment({
    required this.id,
    required this.sectionId,
    required this.title,
    this.titleImage,
    this.orderNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory InfoSegment.fromJson(Map<String, dynamic> json) {
    return InfoSegment(
      id: json['id'],
      sectionId: json['section_id'],
      title: json['title'],
      titleImage: json['titleImage'],
      orderNumber: json['orderNumber'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
