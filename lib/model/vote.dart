class Vote {
  final String id;
  final String title;
  final String description;
  final Map<String, int> items;

  Vote({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
  });

  factory Vote.fromFirestore(Map<String, dynamic> data, String id) {
    return Vote(
      id: id,
      title: data['title'],
      description: data['description'],
      items: Map<String, int>.from(data['items']),
    );
  }
}