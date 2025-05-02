import '../entities/contacts_entity.dart';

abstract class ContactsRepository {
  /// Fetch all contacts associated with the current user (via token).
  Future<List<ContactEntity>> fetchContacts();

  /// Add a contact by email.
  Future<void> addContact({required String email});

  /// Fetch recent contacts for a specific user ID.
  Future<List<ContactEntity>> getRecentContacts({required String userId});
}
