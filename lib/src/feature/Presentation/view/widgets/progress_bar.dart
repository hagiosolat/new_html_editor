import 'package:flutter/material.dart';

class ProgressBars extends StatelessWidget {
  const ProgressBars({
    super.key,
    required this.label,
    required this.progress,
    required this.color,
    this.textColor,
  });

  final String label;
  final double progress;
  final Color color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Container(
          height: 12,
          width:
              !progress.isNaN
                  ? MediaQuery.of(context).size.width * progress
                  : 0.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
