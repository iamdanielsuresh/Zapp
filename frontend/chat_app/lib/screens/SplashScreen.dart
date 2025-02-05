import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,  // Ensure container takes full width
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              const Color(0xFF121212),
              Colors.black.withOpacity(0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(  // Added Center widget here
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.08,
                vertical: screenSize.height * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Center column contents
                crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally
                children: [
                  // Top section with logo placeholder
                  Expanded(
                    flex: 2,
                    child: Center(child: _buildLogoSection()),  // Center the logo
                  ),
                  // Middle section with animated header
                  Expanded(
                    flex: 3,
                    child: Center(child: _buildAnimatedHeader()),  // Center the header
                  ),
                  // Bottom section with buttons
                  Expanded(
                    flex: 2,
                    child: Center(child: _buildBottomSection(context)),  // Center bottom section
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.bolt,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedHeader() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0.0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,  // Take minimum required space
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to ZAP",
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Instant. Simple. Secure.",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            "Experience lightning-fast messaging\nlike never before",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.grey[500],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,  // Take minimum required space
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircularButton(context),
        const SizedBox(height: 30),
        // Existing commented section preserved
        // Widget _buildSignInButton(BuildContext context) {
        //   return TweenAnimationBuilder<double>(
        //     tween: Tween(begin: 0.8, end: 1.0),
        //     duration: const Duration(milliseconds: 900),
        //     curve: Curves.easeOut,
        //     builder: (context, value, child) {
        //       return Transform.scale(
        //         scale: value,
        //         child: child,
        //       );
        //     },
        //     child: TextButton(
        //       onPressed: () => Navigator.pushNamed(context, '/signin'),
        //       style: TextButton.styleFrom(
        //         foregroundColor: Colors.white,
        //       ),
        //       child: const Text(
        //         "Already a member? Sign In",
        //         style: TextStyle(
        //           fontSize: 16,
        //           fontWeight: FontWeight.w500,
        //           decoration: TextDecoration.underline,
        //         ),
        //       ),
        //     ),
        //   );
        // }
        
        // Text(
        //   "Already have an account?",
        //   style: GoogleFonts.poppins(
        //     fontSize: 14,
        //     color: Colors.grey[400],
        //   ),
        //   textAlign: TextAlign.center,  // Ensure text is centered
        // ),
      ],
    );
  }

  Widget _buildCircularButton(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/phone'),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white70],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(  // Center the icon
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}