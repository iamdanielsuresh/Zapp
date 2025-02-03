import 'package:chat_app/components/BottomRightButton.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  // Function to format phone number to E.164
  String formatPhoneNumber(String phone) {
    phone = phone.trim();
    if (!phone.startsWith('+')) {
      phone = '+$phone'; // Ensure it starts with "+"
    }
    return phone.replaceAll(RegExp(r'\s+|-|\(|\)'), ''); // Remove spaces & symbols
  }

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
             // Phone Number Input Field
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]*$')), // Only numbers & optional +
              ],
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: "+91 8095555321",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                String formatted = formatPhoneNumber(value);
                _phoneController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              },
            ),
            Spacer(),
            BottomRightButton(
              onPressed: () async {
                String phoneNumber = '+${_phoneController.text}'; // Add country code prefix
                if (phoneNumber.isNotEmpty) {
                  await sendOtp(phoneNumber); // Call the sendOtp function from the imported file
                  Navigator.pushNamed(context, '/otp'); // Navigate to OTP screen
                } else {
                  print("Please enter a valid phone number");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
