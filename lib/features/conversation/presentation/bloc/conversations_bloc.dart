import 'package:chat_app/core/socket_services.dart';
import 'package:chat_app/features/contacts/domain/usecases/fetch_recent_contacts_usecase.dart';
import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversations_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/fetch_conversations_use_case.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final FetchConversationsUseCase fetchConversationsUseCase;
  final SocketService _socketService = SocketService();

  ConversationsBloc({required this.fetchConversationsUseCase})
      : super(ConversationsInitial()) {
    on<FetchConversations>(_onFetchConversations);
    on<ConversationUpdatedEvent>(_onConversationUpdated);

    _initializeSocketListeners(); // Ensure socket listeners are set
  }

  void _initializeSocketListeners() {
    try {
      if (_socketService.socket.connected) {
        print("Socket connected, adding listener...");
        _socketService.socket.on('conversationUpdated', (data) => add(ConversationUpdatedEvent(data)));
      } else {
        print("Socket not connected yet.");
      }
    } catch (e) {
      print("Error initializing socket listeners: $e");
    }
  }

  Future<void> _onFetchConversations(
      FetchConversations event, Emitter<ConversationsState> emit) async {
    emit(ConversationsLoading());

    try {
      final conversations = await fetchConversationsUseCase();

      if (conversations.isEmpty) {
        emit(ConversationsError('No conversations found'));
      } else {
        emit(ConversationsLoaded(conversations));
      }
    } catch (error) {
      print("Error fetching conversations: ${error.toString()}");
      emit(ConversationsError('Failed to load conversations. Error: ${error.toString()}'));
    }
  }

  void _onConversationUpdated(ConversationUpdatedEvent event, Emitter<ConversationsState> emit) {
    print("Conversation updated, fetching latest...");
    add(FetchConversations());
  }
}

class ConversationUpdatedEvent extends ConversationsEvent {
  final dynamic data;
  ConversationUpdatedEvent(this.data);
}