import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';

abstract class ConversationsState{}


class ConversationsInitial extends ConversationsState{}

class ConversationsLoading extends ConversationsState{}

class ConversationsLoaded extends ConversationsState{
  final List<ConversationEntity> conversations;

  ConversationsLoaded(this.conversations);
}
class RecentContactsLoaded extends ConversationsState{
  final List<ConversationEntity> recentContacts;

  RecentContactsLoaded(this.recentContacts);
}

class ConversationsError extends ConversationsState{
  final String message;

  ConversationsError(this.message);
}