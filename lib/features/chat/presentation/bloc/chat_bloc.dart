import 'dart:async';

import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/usecases/fetch_daily_question_usecase.dart';
import 'package:chat_app/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/socket_services.dart';

class ChatBloc extends Bloc<ChatEvent,ChatState>{
  final FetchMessagesUseCase fetchMessagesUseCase;
  final FetchDailyQuestionUseCase fetchDailyQuestionUseCase;
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _messages =[];
  final _storage = FlutterSecureStorage();


  ChatBloc( {required this.fetchMessagesUseCase,required this.fetchDailyQuestionUseCase}): super(ChatLoadingState()){
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessages);
  on<ReceiveMessageEvent>(_onReceiveMessages);
  on<LoadDailyQuestionEvent>(_onLoadDailyQuestionEvent);

  }


  FutureOr<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async{
  emit(ChatLoadingState());
  try{
    final messages = await fetchMessagesUseCase(event.conversationId);
    _messages.clear();
    _messages.addAll(messages);
    emit(ChatLoadedState(List.from(_messages)));

    _socketService.socket.off('newMessage');


    _socketService.socket.emit('joinConversation',event.conversationId);
    _socketService.socket.on('newMessage', (data) {
      print("step1 - receive : $data");
      add(ReceiveMessageEvent(data));
    });
  }catch(error){
        emit(ChatErrorState('Failed to load messages'));
  }
  }


  FutureOr<void> _onSendMessages(SendMessageEvent event, Emitter<ChatState> emit)async {
  String userId = await _storage.read(key: 'userId')??'';
  print('userId:$userId');

  final newMessage = {
    'conversationId':event.conversationId,
    'content':event.content,
    'senderId': userId,
  };
  _socketService.socket.emit('sendMessage',newMessage);
  }



  FutureOr<void> _onReceiveMessages(ReceiveMessageEvent event, Emitter<ChatState> emit)async {
  print("step2 - receive event called");
  print(event.message);
  final message = MessageEntity(
      id:event.message ['id'],
      conversationId: event.message['conversation_id'],
      senderId: event.message ['sender_id'],
      content:event.message ['content'],
      createdAt: event.message['created_at']);
  _messages.add(message);
  emit(ChatLoadedState(List.from(_messages)));
  }

  Future<void>_onLoadDailyQuestionEvent(LoadDailyQuestionEvent event, Emitter<ChatState> emit)async{
    emit(ChatLoadingState());
    try{
      final dailyQuestion = await fetchDailyQuestionUseCase(event.conversationId);
      emit(ChatDailyQuestionLoadedState(dailyQuestion.first));
    }catch(error){
      emit(ChatErrorState('Failed to load daily question'));
    }
  }
}