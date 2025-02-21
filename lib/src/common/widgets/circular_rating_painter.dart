import 'package:flutter/material.dart';

class CircularRatingBar extends StatelessWidget {
  final double percentage;

  CircularRatingBar({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(40, 40),
      painter: CircularRatingPainter(percentage: percentage),
    );
  }
}

class CircularRatingPainter extends CustomPainter {
  final double percentage;

  CircularRatingPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = Colors.grey.shade300 // Background circle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 7;

    final Paint dividerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, circlePaint);

    double totalAngle = 2 * 3.141592653589793;

    double startAngle = -3.141592653589793 / 2;

    /// Colors for each segment
    List<Color> colors = [
      Colors.orange,

      /// 0-10%
      Colors.orangeAccent,

      /// 10-20%
      Colors.green,

      /// 20-40%
      Colors.greenAccent,

      /// 40-60%
      Colors.blue,

      /// 60-80%
      Colors.blueAccent,

      /// 80-90%
      Colors.pink,

      /// 90-100%
      Colors.yellow,

      /// 100%
    ];

    double segmentSweepAngle = totalAngle / colors.length;

    for (int i = 0; i < colors.length; i++) {
      progressPaint.color = colors[i];

      double sweepAngle;
      if (percentage >= ((i + 1) * 10)) {
        sweepAngle = segmentSweepAngle;
      } else if (percentage > i * 10) {
        sweepAngle = (percentage - i * 10) / 100 * totalAngle;
      } else {
        sweepAngle = 0;
      }

      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: size.width / 2),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      if (i < colors.length - 1) {
        canvas.drawArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2),
              radius: size.width / 2),
          startAngle + sweepAngle,
          0.02,
          false,
          dividerPaint,
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

