import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity{
  MessageModel({
    required String id,
    required String conversatonId,
    required String senderId,
    required String content,
    required String creaatedAt,

  }): super(
    id: id,
    content: content,
    conversationId: conversatonId,
    senderId: senderId,
    createdAt: creaatedAt,
  );
  factory MessageModel.fromJson(Map<String,dynamic>json){
    return MessageModel(id: json['id'],
        conversatonId: json['conversaton_id'],
        senderId: json['sender_id'],
        content: json['content'],
        creaatedAt: json['creaated_at']);
  }
}