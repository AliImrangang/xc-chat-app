import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required String id,
    required String participantName,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) : super(
    id: id,
    participantName: participantName,
    lastMessageTime: lastMessageTime,
    lastMessage: lastMessage,
  );

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    print("Raw JSON: $json");

    return ConversationModel(
      id: json['conversation_id'] ?? '',
      participantName: json['participant_name'] ?? '',
      lastMessage: json['last_message'] ?? 'No messages yet',
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'])
          : DateTime.now(),
    );
  }
}
