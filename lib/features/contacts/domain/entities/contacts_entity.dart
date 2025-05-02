class ContactEntity {
  final String id;
  final String username;
  final String email;
  final String profileImage;

  ContactEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImage,
  });

  factory ContactEntity.fromJson(Map<String, dynamic> json) {
    return ContactEntity(
      id: json['contact_id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
    );
  }
}
