import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:chat_app/features/conversation/data/models/conversations_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConvesationsRemoteDataSource{
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = FlutterSecureStorage();


  Future<List<ConversationModel>>fetchConversations() async{
    String token = await _storage.read(key: 'token')?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Authorization' : 'Bearer $token',
      }
    );

    if(response.statusCode == 200){
      List data = jsonDecode(response.body);
      return data.map((json)=> ConversationModel.fromJson(json)).toList();
    }else{
      throw Exception('Failed to fetch conversation');
    }
  }
}