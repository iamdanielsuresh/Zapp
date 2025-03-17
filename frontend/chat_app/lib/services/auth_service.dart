import 'package:chat_app/screens/NameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/screens/MessageScreen.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
const String baseUrl = 'http://192.168.1.34:8000/api';  // Update with actual server URL

// 🔹 Store JWT token securely
Future<void> storeJwtToken(String token) async {
  await secureStorage.write(key: 'jwt_token', value: token);
}

Future<void> storeRefreshToken(String refreshToken) async {
  await secureStorage.write(key: 'refresh_token', value: refreshToken);
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

  if (response.statusCode == 200 || response.statusCode == 201) {
    final responseData = jsonDecode(response.body);
    print('OTP verified successfully: $responseData');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store tokens if they exist
    if (responseData.containsKey('token')) {
      var tokenData = responseData['token'];
      String accessToken = tokenData['access_token'];
      String refreshToken = tokenData['refresh_token'];

      await storeJwtToken(accessToken);
      await storeRefreshToken(refreshToken);
      prefs.setString('access_token', accessToken);
      prefs.setString('refresh_token', refreshToken);
    }

    // ✅ Declare userId outside the if block
    String? userId;

    if (responseData.containsKey('user_id')) {
      userId = responseData['user_id'].toString();
      await prefs.setString('user_id', userId);
      print("User ID saved: $userId");
    }

    // ✅ Navigate only if userId is not null
    if (responseData['exists'] == true && userId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MessagesScreen(userId: userId!),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NameScreen(phoneNumber: phoneNumber),
        ),
      );
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

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}
