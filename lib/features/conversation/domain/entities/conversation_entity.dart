class ConversationEntity {
  final String id;
  final String participantName;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? participantImage;

  ConversationEntity({
    required this.id,
    required this.participantName,
    this.lastMessage,
    this.lastMessageTime,
    this.participantImage,
  });

  factory ConversationEntity.fromJson(Map<String, dynamic> json) {
    return ConversationEntity(
      id: json['conversation_id'],
      participantName: json['participant_name'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] != null ? DateTime.parse(json['last_message_time']) : null,
      participantImage: json['participant_image'] ?? '', // Ensures a default value if null
    );
  }
}