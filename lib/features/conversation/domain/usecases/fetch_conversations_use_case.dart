import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/conversation/domain/repositories/conversation_repository.dart';

class FetchConversationsUseCase{
  final ConversationRepository repository;

  FetchConversationsUseCase(this.repository);

 Future<List<ConversationEntity>>call()async{
   return repository.fetchConversations();
 }

}