class Employee {
  int? id;
  final String name;
  final String role;
  final DateTime joinDate;
  final DateTime? leaveDate;

  Employee({
    this.id,
    required this.name,
    required this.role,
    required this.joinDate,
    this.leaveDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'joinDate': joinDate.toIso8601String(),
      'leaveDate': leaveDate?.toIso8601String(),
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      joinDate: DateTime.parse(map['joinDate']),
      leaveDate: map['leaveDate'] != null ? DateTime.parse(map['leaveDate']) : null,
    );
  }
}
