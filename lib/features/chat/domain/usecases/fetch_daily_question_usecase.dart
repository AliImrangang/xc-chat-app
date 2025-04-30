import 'package:chat_app/features/chat/domain/entities/daily_question_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/messages_repository.dart';

class FetchDailyQuestionUseCase {
  final MessagesRepository messagesRepository;

  FetchDailyQuestionUseCase({required this.messagesRepository});

Future<List<DailyQuestionEntity>>call (String conversationId) async {
    return await messagesRepository.fetchDailyQuestion(conversationId);
  }
}