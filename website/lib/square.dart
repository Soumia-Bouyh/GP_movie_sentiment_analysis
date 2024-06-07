import 'package:flutter/material.dart';

class SquareWidget extends StatelessWidget {
  final String text;

  SquareWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen
    double screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate the width of the square
    double squareWidth = screenWidth / 14;

    return Container(
      width: squareWidth,
      height: squareWidth, // Make it a square
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey, // Color of the line
            width: 0.01, // Width of the line
          ),
        ),
      ),
      child: Center(
        child: Text(
          style:TextStyle(fontWeight: FontWeight.w500),
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
