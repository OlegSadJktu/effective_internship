class Character {

  const Character({
    required this.id,
    required this.name,
    required this.description,
    this.thumbnailUrl,

  });

  factory Character.fromJson(Map<String, dynamic> data) {
    final name = data['name'];
    final id = data['id'];
    final description = data['description'];
    final thumbnailUrl = '${data['thumbnail']!['path']}.jpg';
    return Character(
        id: id,
        name: name,
        description: description,
        thumbnailUrl: thumbnailUrl
    );
  }

  final int id;
  final String name;
  final String description;
  final String? thumbnailUrl;



}
