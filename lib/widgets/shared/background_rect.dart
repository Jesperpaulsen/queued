import 'package:flutter/material.dart';

class BackgroundRect extends StatelessWidget {
  final Color color;
  final double height;
  BackgroundRect({@required this.color, @required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter:
            BackgroundRectDrawer(rectColor: Theme.of(context).primaryColor),
        child: Container(
          height: height,
        ),
      ),
    );
  }
}

class BackgroundRectDrawer extends CustomPainter {
  final Color rectColor;
  BackgroundRectDrawer({@required this.rectColor});
  final double offset = 80;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = rectColor;

    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 0 + offset);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height - offset);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
