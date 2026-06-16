class User {
  final String id;
  final String name;
  final String username;
  final String? profilePicture;
  final String password;
  final String createdAt;

  const User({
    required this.id,
    required this.name,
    required this.username,
    this.profilePicture,
    required this.password,
    required this.createdAt,
  });
}
