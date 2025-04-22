import 'package:chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:flutter/material.dart';

abstract class ConversationRepsitory{
  Future<List<ConversationEntity>>fetchConversations();
}