import 'package:flutter/material.dart';

class CustomStyleArrow extends CustomPainter {
  final bool isMine;
  final Color bubbleColor;

  CustomStyleArrow({required this.isMine, required this.bubbleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;

    final Path trianglePath = Path();
    const double triangleSize = 4;

    if (isMine) {

      trianglePath.moveTo(size.width, size.height / 2 - triangleSize);
      trianglePath.lineTo(size.width + triangleSize, size.height / 2);
      trianglePath.lineTo(size.width, size.height / 2 + triangleSize);
    } else {
      trianglePath.moveTo(0, size.height / 2 - triangleSize);
      trianglePath.lineTo(-triangleSize, size.height / 2);
      trianglePath.lineTo(0, size.height / 2 + triangleSize);
    }
    trianglePath.close();


    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    canvas.drawRRect(rRect, paint);
    canvas.drawPath(trianglePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomStyleArrow oldDelegate) {
    return oldDelegate.isMine != isMine || oldDelegate.bubbleColor != bubbleColor;
  }
}
