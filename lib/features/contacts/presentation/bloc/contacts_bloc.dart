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
      // Assuming fetchRecentContactsUseCase requires userId as parameter
      final userId = event.userId; // Ensure userId is passed in the event

      // Fetch the recent contacts using the use case
      final List<ConversationEntity> recentContacts = await fetchRecentContactsUseCase(userId: userId);

      // Emit the loaded state with recent contacts
      emit(RecentContactsLoaded(recentContacts));
    } catch (error) {
      // Handle errors and emit the error state with a detailed message
      emit(ContactsError('Failed to fetch recent contacts: ${error.toString()}'));
    }
  }


  Future<void> _onFetchContacts(FetchContacts event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    try {
      final contacts = await fetchContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (error) {
      emit(ContactsError('Failed to fetch contacts: ${error.toString()}'));
    }
  }

  Future<void> _onAddContact(AddContact event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    try {
      await addContactUseCase(email: event.email);
      emit(ContactAdded());
      add(FetchContacts());
    } catch (error) {
      // Log the error message
      print('Error adding contact: $error');
      emit(ContactsError('Failed to add contact: $error'));
    }
  }





  Future<void> _onCheckOrCreateConversation(CheckOrCreateConversation event, Emitter<ContactsState> emit) async {
    try {
      emit(ContactsLoading());

      // Make sure event.contactId is a valid String (UUID)
      final conversationId = await checkOrCreateConversationUseCase(contactId: event.contactId);

      emit(ConversationReady(conversationId: conversationId, contact: event.contact, profileImage: ''));
    } catch (error) {
      print('Error starting conversation: $error');
      emit(ContactsError('Failed to start conversation: $error'));
    }
  }





}
