import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final bool loading;
  final MaterialColor color;
  final MaterialColor textColor;
  final double height;
  final double minWidth;

  LargeButton({
    this.label,
    this.onPressed,
    this.loading,
    this.color,
    this.textColor,
    this.height = 50,
    this.minWidth = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: height,
      minWidth: minWidth,
      child: RaisedButton(
        color: loading ? color.shade800 : color,
        onPressed: onPressed,
        child: loading
            ? CircularProgressIndicator(
                strokeWidth: 1,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                label,
                style: TextStyle(
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
