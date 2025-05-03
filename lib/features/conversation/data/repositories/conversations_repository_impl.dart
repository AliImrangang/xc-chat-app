import 'package:chat_app/features/conversation/data/datasources/conversation_remote_data_source.dart';
import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/conversation/domain/repositories/conversation_repository.dart';

class ConversationsRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource conversationRemoteDataSource;

  ConversationsRepositoryImpl({required this.conversationRemoteDataSource});

  @override
  Future<List<ConversationEntity>> fetchConversations() async {
    return await conversationRemoteDataSource.fetchConversations();
  }

  @override
  Future<String> checkOrCreateConversation({required String contactId}) async {
    print("Checking or creating conversation for contact ID: $contactId");

    // ✅ Ensure proper type handling before passing to remote data source
    final formattedContactId = contactId.trim(); // Clean unnecessary spaces

    return await conversationRemoteDataSource.checkOrCreateConversation(contactId: formattedContactId);
  }
}