import 'package:chat_app/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversations_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/fetch_conversations_use_case.dart';


class ConversationsBloc extends Bloc<ConversationsEvent,ConversationsState> {
  final FetchConversationsUseCase fetchConversationsUseCase;

  ConversationsBloc({required this.fetchConversationsUseCase})
      :super(ConversationsInitial()) {
    on<FetchConversations>(_onFetchConversations);
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
}