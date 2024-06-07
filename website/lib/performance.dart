import 'package:flutter/material.dart';

class PerformanceIndicatorsRow extends StatelessWidget {
  final double accuracy;
  final double precision;
  final double recall;
  final double f1Score;

  PerformanceIndicatorsRow({
    required this.accuracy,
    required this.precision,
    required this.recall,
    required this.f1Score,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIndicator("Accuracy", accuracy),
        _buildIndicator("Precision", precision),
        _buildIndicator("Recall", recall),
        _buildIndicator("F1 Score", f1Score),
      ],
    );
  }

  Widget _buildIndicator(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}
