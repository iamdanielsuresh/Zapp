import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendOtp(String phoneNumber) async {
  print(phoneNumber);
  final url = Uri.parse('http://192.168.1.36:8000/api/send-otp/');
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
    Uri.parse('http://192.168.1.36:8000/api/verify-otp/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'phone': phoneNumber, 'otp': otp}),
  );

  if (response.statusCode == 200) {
    print('OTP verified successfully');
    // Navigate to the Name screen after success
    Navigator.pushNamed(context, '/Name');
  } else {
    print('Failed to verify OTP: ${response.body}');
    // Handle error (e.g., show error message to user)
  }
}