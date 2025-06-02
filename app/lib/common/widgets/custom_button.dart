import "package:flutter/material.dart";

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: backgroundColor ?? Colors.grey[500],
        foregroundColor: textColor ?? Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
      ),
      child: Text(
        text ?? 'Button',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
