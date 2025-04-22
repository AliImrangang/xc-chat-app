import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity{



  ConversationModel({
    required id,
    required participantName,
    required lastMessage,
    required lastMessageTime}):super(
  id:id,
  participantName: participantName,
  lastMessageTime: lastMessageTime,
  lastMessage: lastMessage,
  );

  factory ConversationModel.fromJson(Map<String,dynamic>json){
      return ConversationModel(
          id: json['conversation_id'],
          participantName: ['participant_name'],
          lastMessage: ['last_message'],
          lastMessageTime: DateTime.parse(json['last_message_time']));
    
  }




}