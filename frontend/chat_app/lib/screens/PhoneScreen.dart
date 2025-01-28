import 'package:chat_app/components/BottomRightButton.dart';
import 'package:flutter/material.dart';

class PhoneScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            Text("What’s your number?", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text("We’ll send you a code to verify your number."),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: "+91 809 5555 321",
              ),
            ),
            Spacer(),
            BottomRightButton(
              onPressed: () {
                Navigator.pushNamed(context, '/otp'); // Navigate to the OTP screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
