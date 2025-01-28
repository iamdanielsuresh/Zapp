import 'package:flutter/material.dart';

class BottomRightButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double buttonSize;
  final double iconSize;

  const BottomRightButton({
    Key? key,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.buttonSize = 60,
    this.iconSize = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              minimumSize: MaterialStateProperty.all(Size(buttonSize, buttonSize)),
              shape: MaterialStateProperty.all(CircleBorder()), // Circular button style
              elevation: MaterialStateProperty.all(5), // Add shadow effect
            ),
        onPressed: onPressed,
        child: Icon(
          icon,
          size: iconSize, // Icon size
        ),
      ),
    );
  }
}
