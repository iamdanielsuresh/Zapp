import 'package:chat_app/screens/NameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
const String baseUrl = 'http://10.0.2.2:8000/api';  // Update with actual server URL

// 🔹 Store JWT token securely
Future<void> storeJwtToken(String token) async {
  await secureStorage.write(key: 'jwt_token', value: token);
}

// 🔹 Retrieve JWT token
Future<String?> getJwtToken() async {
  return await secureStorage.read(key: 'jwt_token');
}

// 🔹 Delete JWT token (Logout)
Future<void> logout() async {
  await secureStorage.delete(key: 'jwt_token');
}

// ✅ 1️⃣ Send OTP Request
Future<void> sendOtp(String phoneNumber) async {
  final url = Uri.parse('$baseUrl/send-otp/');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'phone': phoneNumber});

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('OTP sent successfully');
    } else {
      print('Failed to send OTP: ${response.body}');
    }
  } catch (e) {
    print('Error sending OTP: $e');
  }
}

// ✅ 2️⃣ Verify OTP & Store JWT Token
Future<void> verifyOtp(BuildContext context, String phoneNumber, String otp) async {
  final response = await http.post(
    Uri.parse('$baseUrl/verify-otp/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'phone': phoneNumber, 'otp': otp}),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    print('OTP verified successfully: $responseData');

    if (responseData.containsKey('token')) {
      String token = responseData['token'];

      // Store JWT securely
      await storeJwtToken(token);
    }

    if (responseData['exists'] == true) {
      Navigator.pushReplacementNamed(context, '/contacts');
    } else {
      Navigator.pushNamed(context, '/Name', arguments: phoneNumber);
    }
  } else {
    print('Failed to verify OTP: ${response.body}');
  }
}

// ✅ 3️⃣ Update User Details (Authenticated Request)
Future<bool> updateUserDetails({
  required String phoneNumber,
  required String name,
  required String email,
  required String description,
  File? image,
}) async {
  String? base64Image;
  if (image != null) {
    List<int> imageBytes = await image.readAsBytes();
    base64Image = "data:image/png;base64," + base64Encode(imageBytes);
  }

  String? token = await getJwtToken();
  if (token == null) {
    print("User not authenticated");
    return false;
  }

  final response = await http.put(
    Uri.parse("$baseUrl/update-user/"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "phone_number": phoneNumber,
      "name": name,
      "email": email,
      "description": description,
      "profile_image": base64Image ?? "",
    }),
  );

  return response.statusCode == 200;
}
