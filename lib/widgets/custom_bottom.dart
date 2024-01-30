import 'package:flutter/material.dart';

class CustomBottom extends StatelessWidget {
  const CustomBottom({
    super.key,
    required this.icon, required this.color,
    
  });
  final IconData icon;
  final MaterialColor color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon,color: color,),
    );
  }
}