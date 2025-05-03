import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import '../../../conversation/presentation/bloc/conversations_event.dart';
import '../../domain/entities/contacts_entity.dart';

abstract class ContactsEvent {
  const ContactsEvent(); // ✅ Ensures proper event initialization
}

class FetchContacts extends ContactsEvent {
  const FetchContacts();
}

class CheckOrCreateConversation extends ContactsEvent {
  final String contactId;
  final ContactEntity contact;
  final String? profileImage;

  CheckOrCreateConversation({
    required this.contactId,
    required this.contact,
    this.profileImage,
  });
}

class AddContact extends ContactsEvent {
  final String email;

  AddContact({required this.email});
}

class LoadRecentContacts extends ContactsEvent {
  final String userId;

  LoadRecentContacts({required this.userId});
}