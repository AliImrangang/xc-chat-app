import 'dart:convert';
import 'package:chat_app/core/link_helper.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:3000/auth';
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['user'] != null) {
      return UserModel.fromJson(responseBody['user']);
    } else {
      final error = responseBody['message'] ?? 'Login failed';
      throw Exception(error);
    }
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['user'] != null) {
      return UserModel.fromJson(responseBody['user']);
    } else {
      final error = responseBody['message'] ?? 'Registration failed';
      throw Exception(error);
    }
  }
}