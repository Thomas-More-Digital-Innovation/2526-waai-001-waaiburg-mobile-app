class Section {
  final int id;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  const Section({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
