class Event {
  String id;
  String name;
  DateTime date;
  String location;
  String description;
  String userId;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'location': location,
      'description': description,
      'user_id': userId,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      name: map['name'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      location: map['location'] as String,
      description: map['description'] as String,
      userId: map['user_id'] as String,
    );
  }
}
