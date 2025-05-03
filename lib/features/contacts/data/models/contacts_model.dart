import '../../domain/entities/contacts_entity.dart';

class ContactsModel extends ContactEntity {
  ContactsModel({
    required String id,
    required String username,
    required String email,
    required String profileImage,
  }) : super(
    id: id,
    email: email,
    username: username,
    profileImage: profileImage,
  );

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    try {
      return ContactsModel(
        id: json['contact_id']?.toString() ?? '', // ✅ Ensure `id` is always a string
        username: json['username'] ?? 'Unknown', // ✅ Handle missing username
        email: json['email'] ?? 'No Email', // ✅ Handle missing email
        profileImage: json['profile_image']?.toString() ?? 'https://via.placeholder.com/150', // ✅ Prevent null errors
      );
    } catch (e) {
      print("Error parsing ContactsModel: $e"); // ✅ Debugging log
      throw Exception("Failed to parse contact data");
    }
  }
}