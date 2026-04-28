import 'package:flutter/material.dart';

class ConcaveRadiusClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.3, 0.0);
    path.quadraticBezierTo(size.width * .2, size.height * 0.5, 0, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
      size.width * .8,
      size.height * 0.5,
      size.width * 0.7,
      0,
    );
    path.lineTo(size.width * 0.3, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
