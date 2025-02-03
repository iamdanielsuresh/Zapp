// otp_screen.dart
import 'package:chat_app/components/BottomRightButton.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What’s the code?", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text("Enter the code we sent to your number."),
            SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
              ),
              maxLength: 6,
            ),
            Spacer(),
            BottomRightButton(
              onPressed: ()  {
                final otp = _otpController.text;
                if (otp.isNotEmpty) {
                  verifyOtp(context,phoneNumber, otp);
                } else {
                  // Handle empty OTP (show an error message or snack bar)
                  print("Please enter OTP");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
