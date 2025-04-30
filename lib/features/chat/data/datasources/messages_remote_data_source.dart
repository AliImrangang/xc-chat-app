import 'dart:convert';
import 'package:chat_app/features/chat/data/models/daily_question_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MessagesRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:3000'; // Ensure correct base URL
  final _storage = FlutterSecureStorage();

  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token is empty or not available');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/messages/$conversationId'), // Correct URL
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        // Map the response data to MessageModel
        return data.map((json) => MessageModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch messages, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      throw Exception('Failed to fetch messages: $e');
    }
  }
Future<DailyQuestionModel> fetchDailyQuestion(String conversationId) async {
  String token = await _storage.read(key: 'token') ?? '';

  if (token.isEmpty) {
    throw Exception('Token is empty or not available');
  }

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$conversationId/daily-question'), // Correct URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return DailyQuestionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to fetch messages, status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching messages: $e');
    throw Exception('Failed to fetch messages: $e');
  }
}}
