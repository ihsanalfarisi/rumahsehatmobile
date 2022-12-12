class Apoteker {
  final String uuid;
  final String nama;
  final String username;
  final String email;
  final String role;

  Apoteker({
    required this.uuid,
    required this.nama,
    required this.username,
    required this.email,
    required this.role,
  });

  factory Apoteker.fromJson(Map<String, dynamic> json) => Apoteker(
        uuid: json["uuid"],
        nama: json["nama"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "nama": nama,
        "username": username,
        "email": email,
        "role": role,
      };
}
