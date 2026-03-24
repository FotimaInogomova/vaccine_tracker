class Parent {
  final int? id;
  final String email;
  final String passwordHash;
  final String name;

  Parent({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password_hash': passwordHash,
      'name': name,
    };
  }

  factory Parent.fromMap(Map<String, dynamic> map) {
    return Parent(
      id: map['id'],
      email: map['email'],
      passwordHash: map['password_hash'],
      name: map['name'],
    );
  }
}
