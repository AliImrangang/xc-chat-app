import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';

import '../../../conversation/presentation/bloc/conversations_event.dart';
import '../../domain/entities/contacts_entity.dart';

abstract class ContactsEvent{}

class FetchContacts extends ContactsEvent{}
class CheckOrCreateConversation extends ContactsEvent{
  final String contactId;
  final ContactEntity contact;
  CheckOrCreateConversation(this.contactId,this.contact);
}

class AddContact extends ContactsEvent{
  final String email;

  AddContact(this.email);
}

class LoadRecentContacts extends ContactsEvent {
  final String userId;

  LoadRecentContacts({required this.userId});
}