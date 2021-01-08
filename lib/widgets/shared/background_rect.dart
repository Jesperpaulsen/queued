import 'package:flutter/material.dart';
import 'package:queued/configs/colors.dart';

class BackgroundRect extends StatelessWidget {
  final Color color;
  final double height;
  final Widget child;
  BackgroundRect({
    @required this.child,
    this.height,
    color,
  }) : this.color = color ?? AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height ?? MediaQuery.of(context).size.height * 0.7,
        width: double.infinity,
        child: ClipPath(
          clipper: BackgroundClipper(),
          child: Container(
            color: AppColors.primary,
            child: child,
          ),
        ),
      ),
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  final double offset = 80;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 0 + offset);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height - offset);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
