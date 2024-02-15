

class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isPrimeMember;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isPrimeMember,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isPrimeMember: map['isPrimeMember'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isPrimeMember': isPrimeMember,
    };
  }
}
