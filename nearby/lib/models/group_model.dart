class Group {
  final String id;
  final String name;
  final String description;
  final String subtitle;
  final String imageUrl;
  final List<String> interests;
  final int memberCount;
  final String? category;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.subtitle,
    required this.imageUrl,
    required this.interests,
    required this.memberCount,
    this.category,
  });
}