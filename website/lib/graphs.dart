import 'package:flutter/material.dart';

class ModelPerformanceRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildImageWithZoom(
            'confusion_matrix.png', 'Confusion Matrix', context),
        _buildImageWithZoom('auc_curve.png', 'AUC Curve', context),
        _buildImageWithZoom('bar_plot.png', 'Bar Plot', context),
      ],
    );
  }

  Widget _buildImageWithZoom(
      String imagePath, String imageName, BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Adjusted border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Adjusted shadow color
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _showImageDialog(imagePath, context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 200, // Adjust the size as needed
                height: 200, // Adjust the size as needed
              ),
            ),
          ),
          SizedBox(height: 8), // Add some space between the image and text
          Text(
            imageName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(String imagePath, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
