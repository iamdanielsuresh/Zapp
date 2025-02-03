import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FirebaseAuth auth = FirebaseAuth.instance;

// 🔹 Send OTP
Future<void> sendOtp(String phoneNumber) async {
  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
      print("Phone number automatically verified!");
    },
    verificationFailed: (FirebaseAuthException e) {
      print("Verification Failed: ${e.message}");
    },
    codeSent: (String verificationId, int? resendToken) {
      print("OTP Sent. Verification ID: $verificationId");
      // Store this verificationId for later use
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      print("Auto retrieval timeout.");
    },
  );
}

// 🔹 Verify OTP Manually
Future<void> verifyOtp(String verificationId, String otp) async {
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    await auth.signInWithCredential(credential);
    print("OTP Verified Successfully!");
  } catch (e) {
    print("Failed to verify OTP: ${e.toString()}");
  }
}

// 🔹 Verify with Django
Future<void> verifyWithDjango() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    String? idToken = await user.getIdToken();  // Get Firebase ID token

    final response = await http.post(
      Uri.parse("http://your-django-backend.com/api/verify_firebase_token/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"firebase_id_token": idToken}),
    );

    if (response.statusCode == 200) {
      print("✅ Login successful: ${response.body}");
    } else {
      print("❌ Login failed: ${response.body}");
    }
  }
}
