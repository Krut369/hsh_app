class StudentResult {
  final String id;
  final String studentName;
  final String room;
  final String studentId;
  final double cgpa;
  final String grade;
  final String semester;
  final Map<String, SubjectResult> subjects;

  StudentResult({
    required this.id,
    required this.studentName,
    required this.room,
    required this.studentId,
    required this.cgpa,
    required this.grade,
    required this.semester,
    required this.subjects,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentName': studentName,
        'room': room,
        'studentId': studentId,
        'cgpa': cgpa,
        'grade': grade,
        'semester': semester,
        'subjects': subjects.map((key, value) => MapEntry(key, value.toMap())),
      };

  factory StudentResult.fromMap(Map<String, dynamic> map) => StudentResult(
        id: map['id'],
        studentName: map['studentName'],
        room: map['room'],
        studentId: map['studentId'],
        cgpa: map['cgpa'].toDouble(),
        grade: map['grade'],
        semester: map['semester'],
        subjects: Map<String, SubjectResult>.from(
          (map['subjects'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, SubjectResult.fromMap(value)),
          ),
        ),
      );
}

class SubjectResult {
  final String subjectName;
  final double marks;
  final String grade;

  SubjectResult({
    required this.subjectName,
    required this.marks,
    required this.grade,
  });

  Map<String, dynamic> toMap() => {
        'subjectName': subjectName,
        'marks': marks,
        'grade': grade,
      };

  factory SubjectResult.fromMap(Map<String, dynamic> map) => SubjectResult(
        subjectName: map['subjectName'],
        marks: map['marks'].toDouble(),
        grade: map['grade'],
      );
}
