class HedieatyUser {
  String id;
  String name;
  String email;
  String phone;

  HedieatyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  static HedieatyUser fromMap(Map<String, dynamic> map) {
    return HedieatyUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
    );
  }
}
