class Password {
  int? id;
  String title;
  String username;
  String password;
  String? website;
  String? note;
  DateTime createdAt;
  DateTime updatedAt;

  Password({
    this.id,
    required this.title,
    required this.username,
    required this.password,
    this.website,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'website': website,
      'note': note,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      password: map['password'],
      website: map['website'],
      note: map['note'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}