import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime date;
  final DateTime? updatedAt;
  final bool isPinned;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.date,
    this.updatedAt,
    this.isPinned = false,
  });

  Note copyWith({
    String? id,
    String? title,
    String? body,
    String? category,
    DateTime? date,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      date: date ?? this.date,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'date': date.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      category: map['category']?.toString() ?? 'General',
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      isPinned: map['isPinned'] == true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, body: $body, category: $category, date: $date, updatedAt: $updatedAt, isPinned: $isPinned)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.category == category &&
        other.date == date &&
        other.updatedAt == updatedAt &&
        other.isPinned == isPinned;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        category.hashCode ^
        date.hashCode ^
        updatedAt.hashCode ^
        isPinned.hashCode;
  }
}
