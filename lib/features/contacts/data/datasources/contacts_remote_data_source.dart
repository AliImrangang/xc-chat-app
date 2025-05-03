import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/contacts_model.dart';

class ContactsRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = FlutterSecureStorage();

  Future<List<ContactsModel>> fetchContacts() async {
    String token = await _storage.read(key: 'token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contacts'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Raw API Response (fetchContacts): ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        if (data.isEmpty) {
          print("No contacts found.");
          return [];
        }

        return data.map((json) => ContactsModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch contacts. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching contacts: ${error.toString()}");
      throw Exception("Failed to fetch contacts: ${error.toString()}");
    }
  }

  Future<void> addContact({required String email}) async {
    String token = await _storage.read(key: 'token') ?? '';

    try {
      print("Sending request to add contact with email: $email");

      final response = await http.post(
        Uri.parse('$baseUrl/contacts'), // ✅ Backend now accepts email directly
        body: jsonEncode({'email': email}), // 🔹 Use email instead of contactId
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Raw API Response (addContact): ${response.body}");

      if (response.statusCode == 201) {
        print("Contact added successfully!");
      } else {
        final errorData = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        final errorMessage = errorData.containsKey('error')
            ? errorData['error']
            : "Unknown error occurred.";

        throw Exception("Failed to add contact: $errorMessage");
      }
    } catch (error) {
      print("Error adding contact: ${error.toString()}");
      throw Exception("Failed to add contact: ${error.toString()}");
    }
  }  Future<List<ContactsModel>> fetchRecentContacts({required String userId}) async {
    String token = await _storage.read(key: 'token') ?? '';

    try {
      final cleanedUserId = userId.trim();
      if (cleanedUserId.isEmpty) {
        throw Exception("Invalid user ID: It cannot be empty.");
      }

      print("Fetching recent contacts for user ID: $cleanedUserId");

      final response = await http.get(
        Uri.parse('$baseUrl/contacts/recent/$cleanedUserId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Raw API Response (fetchRecentContacts): ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (!jsonResponse.containsKey('contacts')) {
          throw Exception("Invalid response format: Missing 'contacts' key.");
        }

        List<dynamic> data = jsonResponse['contacts'];
        if (data.isEmpty) {
          print("No recent contacts found.");
          return [];
        }

        return data.map((json) => ContactsModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch recent contacts. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching recent contacts: ${error.toString()}");
      throw Exception("Failed to fetch recent contacts: ${error.toString()}");
    }
  }
}