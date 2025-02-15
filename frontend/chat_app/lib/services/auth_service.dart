import 'package:chat_app/screens/NameScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<void> sendOtp(String phoneNumber) async {
  print(phoneNumber);
  final url = Uri.parse('http://10.0.2.2:8000/api/send-otp/');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'phone': phoneNumber});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('OTP sent successfully');
      // Handle success (e.g., navigate to OTP verification screen)
    } else {
      print('Failed to send OTP: ${response.body}');
      // Handle failure (e.g., show error message to user)
    }
  } catch (e) {
    print('Error sending OTP: $e');
    // Handle error (e.g., show error message to user)
  }
}

Future<void> verifyOtp(BuildContext context, String phoneNumber, String otp) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/api/verify-otp/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'phone': phoneNumber, 'otp': otp}),
  );

  if (response.statusCode == 200) {
    print('OTP verified successfully');
    final responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData['exists'] == true) {
      Navigator.pushReplacementNamed(context,'/contacts');
    }else{
      Navigator.pushNamed(context, '/Name',arguments: phoneNumber);
    }
  } else {
    print('Failed to verify OTP: ${response.body}');
    // Handle error (e.g., show error message to user)
  }
}

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

  final response = await http.put(
    Uri.parse("http://your-server-url/api/update-user/"),
    headers: {"Content-Type": "application/json"},
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