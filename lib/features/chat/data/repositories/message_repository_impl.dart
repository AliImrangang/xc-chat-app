import 'package:chat_app/features/chat/data/datasources/messages_remote_data_source.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository{
  final MessagesRemoteDataSource remoteDataSource;

  MessagesRepositoryImpl({required this.remoteDataSource});


  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
return await remoteDataSource.fetchMessages(conversationId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    throw UnimplementedError();
  }}