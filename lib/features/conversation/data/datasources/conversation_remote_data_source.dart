import 'dart:convert';
import 'package:chat_app/core/link_helper.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/features/conversation/data/models/conversations_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConversationRemoteDataSource {
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversations() async {
    String? token = await _storage.read(key: 'token');

    // Ensure the token is not null or empty
    if (token == null || token.isEmpty) {
      throw Exception('Token is missing or empty');
    }

    try {
      final response = await http.get(
        Uri.parse('${LinkHelper.rootUrl}/conversations'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          List data = jsonDecode(response.body);
          print('Decoded Data: $data');
          return data.map((json) => ConversationModel.fromJson(json)).toList();
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to decode conversations');
        }
      } else {
        print(
          'Failed to fetch conversations. Status code: ${response.statusCode}',
        );
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      print('Error fetching conversations: $e');
      throw Exception('Failed to fetch conversations: $e');
    }
  }

  Future<String> checkOrCreateConversation({required String contactId}) async {
    String? token = await _storage.read(key: 'token');

    // Ensure the token is not null or empty
    if (token == null || token.isEmpty) {
      throw Exception('Token is missing or empty');
    }

    try {
      final response = await http.post(
        Uri.parse('${LinkHelper.rootUrl}/conversations/check-or-create'),
        body: jsonEncode({'contactId': contactId}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['conversationId'];
      } else {
        print(
          'Failed to check or create conversation. Status code: ${response.statusCode}',
        );
        throw Exception('Failed to check or create conversation');
      }
    } catch (e) {
      print('Error checking or creating conversation: $e');
      throw Exception('Failed to check or create conversation: $e');
    }
  }
}
