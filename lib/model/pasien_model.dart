class Pasien {
  final String uuid;
  final String nama;
  final String username;
  final String email;
  final String role;
  final int saldo;

  Pasien({
    required this.uuid,
    required this.nama,
    required this.username,
    required this.email,
    required this.role,
    required this.saldo
  });

    factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
        uuid: json["uuid"],
        nama: json["nama"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
        saldo: json["saldo"]
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "nama": nama,
        "username": username,
        "email": email,
        "role": role,
        "saldo": saldo
      };
}