class Task {
  static const String collectionName ='tasks';
  String id;
  String title;
  String description;
  DateTime dateTime;


  Task({
    this.id = '',
    required this.title,
    required this.description,
    required this.dateTime,

  });

  factory Task.fromFireStore(Map<String, dynamic> data) {
    return Task(
      id: data['id'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime'] as int),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

}