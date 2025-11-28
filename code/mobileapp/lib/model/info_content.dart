import 'package:mobileapp/model/sortable.dart';

class InfoContent extends Sortable {
  @override
  final int? orderNumber;

  final int id;
  final int infoId;
  final String title;
  final String? titleImage;
  final String? url;
  final String? shortContent;
  final String? content;
  final String? createdAt;
  final String? updatedAt;

  InfoContent({
    required this.id,
    required this.infoId,
    required this.title,
    this.titleImage,
    this.url,
    this.shortContent,
    this.content,
    this.orderNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory InfoContent.fromJson(Map<String, dynamic> json) {
    return InfoContent(
      id: json['id'],
      infoId: json['info_id'],
      title: json['title'],
      titleImage: json['titleImage'],
      url: json['url'],
      shortContent: json['shortContent'],
      content: json['content'],
      orderNumber: json['orderNumber'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
