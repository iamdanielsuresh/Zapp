import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use theme background color
      body: Center( // Center the entire column
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center content
            crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center content
            children: [
              // App name or logo styled to match the NameScreen
              Text(
                "Are you Ready for",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium?.color, // Consistent with NameScreen text color
                    ),
              ),
              SizedBox(height: 40),
              Text(
                "Zapp!!!",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium?.color, // Consistent with NameScreen text color
                    ),
              ),
              SizedBox(height: 40),

              // 'Get Started' Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/phone'); // Navigate to NameScreen
                },
                child: Text("Get Started"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor, // Button background color
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor, // Updated to foregroundColor for text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded button corners
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 'Sign In' Text Link
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin'); // Navigate to SignInScreen
                },
                child: Text(
                  "Already a member? Sign In",
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color), // Use consistent text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
