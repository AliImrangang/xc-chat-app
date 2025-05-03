import 'dart:async';

import 'package:chat_app/features/contacts/domain/usecases/add_contact_usecase.dart';
import 'package:chat_app/features/contacts/domain/usecases/fetch_contacts_usecase.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:chat_app/features/contacts/presentation/bloc/contacts_state.dart';
import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/conversation/domain/usecases/check_or_create_conversation_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../conversation/presentation/bloc/conversation_state.dart';
import '../../domain/usecases/fetch_recent_contacts_usecase.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final FetchContactUseCase fetchContactsUseCase;
  final AddContactUseCase addContactUseCase;
  final FetchRecentContactsUseCase fetchRecentContactsUseCase;
  final CheckOrCreateConversationUseCase checkOrCreateConversationUseCase;

  ContactsBloc({
    required this.fetchContactsUseCase,
    required this.addContactUseCase,
    required this.checkOrCreateConversationUseCase,
    required this.fetchRecentContactsUseCase,
  }) : super(ContactsInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContact);
    on<CheckOrCreateConversation>(_onCheckOrCreateConversation);
    on<LoadRecentContacts>(_onLoadRecentContactsEvent);
  }

  Future<void> _onLoadRecentContactsEvent(LoadRecentContacts event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    try {
      final userId = event.userId.trim();

      if (userId.isEmpty) {
        emit(ContactsError("Invalid user ID"));
        return;
      }

      print("Fetching recent contacts for user ID: $userId");
      final List<ConversationEntity> recentContacts = await fetchRecentContactsUseCase(userId: userId);

      if (recentContacts.isEmpty) {
        emit(ContactsError("No recent contacts found"));
      } else {
        emit(RecentContactsLoaded(recentContacts));
      }
    } catch (error) {
      print("Error fetching recent contacts: ${error.toString()}");
      emit(ContactsError("Failed to fetch recent contacts: ${error.toString()}"));
    }
  }

  Future<void> _onFetchContacts(FetchContacts event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    try {
      print("Fetching all contacts...");
      final contacts = await fetchContactsUseCase();

      if (contacts.isEmpty) {
        emit(ContactsError("No contacts found"));
      } else {
        emit(ContactsLoaded(contacts));
      }
    } catch (error) {
      print("Error fetching contacts: ${error.toString()}");
      emit(ContactsError("Failed to fetch contacts: ${error.toString()}"));
    }
  }

  Future<void> _onAddContact(AddContact event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());

    try {
      final email = event.email.trim();

      if (email.isEmpty || !email.contains('@')) { // ✅ Validate email format
        print("Invalid email format: $email");
        emit(ContactsError("Invalid email: Please provide a valid email address."));
        return;
      }

      print("Adding contact with email: $email");

      await addContactUseCase(email: email).timeout(
        Duration(seconds: 10),
        onTimeout: () => throw Exception("Request timed out. Please try again."),
      );

      print("Contact added successfully!");
      emit(ContactAdded());

      add(FetchContacts()); // ✅ Refresh contact list after adding a contact
    } catch (error) {
      print("Error adding contact: ${error.toString()}");
      emit(ContactsError("Failed to add contact: ${error.toString()}"));
    }
  }  Future<void> _onCheckOrCreateConversation(CheckOrCreateConversation event, Emitter<ContactsState> emit) async {
    try {
      emit(ContactsLoading());

      final contactId = event.contactId.trim();
      if (contactId.isEmpty) {
        emit(ContactsError("Invalid contact ID: Cannot be empty."));
        return;
      }

      print("Checking or creating conversation for contact ID: $contactId");

      // ✅ Ensure correct type conversion before passing to use case
      final formattedContactId = int.tryParse(contactId) ?? contactId; // Handle int vs string issue

      // ✅ Call repository method with properly formatted ID
      final conversationId = await checkOrCreateConversationUseCase(contactId: formattedContactId.toString());

      if (conversationId.isEmpty) {
        emit(ContactsError("Conversation could not be created."));
        return;
      }

      emit(ConversationReady(
        conversationId: conversationId,
        contact: event.contact,
        profileImage: event.profileImage ?? "https://via.placeholder.com/150", // Handle null case with default image
      ));

    } catch (error) {
      print("Error starting conversation: ${error.toString()}");
      emit(ContactsError("Failed to start conversation: ${error.toString()}"));
    }
  }}