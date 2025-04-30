import 'package:chat_app/features/contacts/domain/entities/contacts_entity.dart';

import '../../../conversation/domain/entities/conversation_entity.dart';

abstract class ContactsState{
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState{}

class ContactsLoaded extends ContactsState{
  final List<ContactEntity> contacts;

  ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState{
  final String message;

  ContactsError(this.message);
}
class ContactAdded extends ContactsState {}
class ConversationReady extends ContactsState {
  final String conversationId;
  final ContactEntity contact;
  final String profileImage;

  ConversationReady({required this.profileImage,required this.conversationId, required this.contact});
}