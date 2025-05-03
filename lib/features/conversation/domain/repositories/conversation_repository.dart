import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:flutter/material.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversations();

  Future<String> checkOrCreateConversation({required String contactId}); // ✅ Ensure consistent type
}