import 'package:chat_app/core/socket_services.dart';
import 'package:chat_app/features/contacts/domain/usecases/fetch_recent_contacts_usecase.dart';
import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversations_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/fetch_conversations_use_case.dart';


class ConversationsBloc extends Bloc<ConversationsEvent,ConversationsState> {
  final FetchConversationsUseCase fetchConversationsUseCase;
  final SocketService _socketService = SocketService();

  ConversationsBloc({required this.fetchConversationsUseCase})
      :super(ConversationsInitial()) {
    on<FetchConversations>(_onFetchConversations);
  }

  void _initializeSocketListeners(){
    try{
      _socketService.socket.on('conversationUpdated', _onConversationUpdated);

    }catch(e){
      print("Error initializing socket listeners : $e");
    }
  }

  Future<void> _onFetchConversations(FetchConversations events,
      Emitter<ConversationsState> emit) async {
    emit(ConversationsLoading());
    try {
      final conversations = await fetchConversationsUseCase();
      emit(ConversationsLoaded(conversations));
    } catch (error) {
      emit(ConversationsError('Failed to load conversations'));
    }
  }



  void _onConversationUpdated(data){
   add(FetchConversations()) ;
  }
}