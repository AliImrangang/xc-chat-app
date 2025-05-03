import 'package:chat_app/features/conversation/domain/repositories/conversation_repository.dart';

class CheckOrCreateConversationUseCase {
  final ConversationRepository conversationRepository;

  CheckOrCreateConversationUseCase({required this.conversationRepository});

  Future<String> call({required String contactId}) async {
    try {
      // ✅ Ensure contactId is correctly formatted before passing it
      final cleanedContactId = contactId.trim();
      print("Checking or creating conversation for contact ID: $cleanedContactId");

      // ✅ Convert contactId to int if required
      final formattedContactId = int.tryParse(cleanedContactId) ?? cleanedContactId;

      // ✅ Call repository method and ensure proper type handling
      final conversationId = await conversationRepository.checkOrCreateConversation(contactId: formattedContactId.toString());

      return conversationId; // ✅ Ensures returned conversation ID is a string
    } catch (error) {
      print("Error checking or creating conversation: ${error.toString()}");
      throw Exception("Failed to check or create conversation: ${error.toString()}");
    }
  }
}