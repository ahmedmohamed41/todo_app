import 'package:flutter/material.dart';

class CustomBottom extends StatelessWidget {
  const CustomBottom({
    super.key,
    required this.icon, required this.color, this.onPressed,
    
  });
  final IconData icon;
  final MaterialColor color;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon,color: color,),
    );
  }
}