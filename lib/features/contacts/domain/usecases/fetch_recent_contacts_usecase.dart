import '../../../conversation/domain/entities/conversation_entity.dart';
import '../entities/contacts_entity.dart';
import '../repositories/contacts_repository.dart';

class FetchRecentContactsUseCase {
  final ContactsRepository contactsRepository;

  FetchRecentContactsUseCase({required this.contactsRepository});

  Future<List<ConversationEntity>> call({required String userId}) async {
    try {
      // Fetch the recent contacts from the repository using userId
      final List<ContactEntity> recentContacts = await contactsRepository.getRecentContacts(userId: userId);

      // Map the ContactEntity list to ConversationEntity list
      return recentContacts.map((ContactEntity contact) {
        return ConversationEntity(
          id: contact.id, // UUID from backend
          participantName: contact.username, // Assuming username is from ContactEntity
          participantImage: contact.profileImage, // Assuming profileImage is from ContactEntity
          lastMessage: 'No messages yet', // Placeholder, update when real message is available
          lastMessageTime: DateTime.now(), // Placeholder, should come from backend if needed
        );
      }).toList();
    } catch (e) {
      // Handle errors, log them if needed
      print('Error fetching recent contacts: $e');
      return []; // Return an empty list in case of error
    }
  }
}
