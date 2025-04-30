import '../../domain/entities/contacts_entity.dart';

class ContactsModel extends ContactEntity {
  ContactsModel({required String id, required String username,required String email,required String profileImage})
      : super(id: id, email: email, username: username,profileImage: profileImage);

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
      id: json['contact_id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'] ?? 'https://via.placeholder.com/150',
    );
  }
}