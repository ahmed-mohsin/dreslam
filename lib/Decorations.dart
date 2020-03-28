import 'package:flutter/material.dart';

decorationImage(String imageName) {
  return DecorationImage(
      image: AssetImage("assets/$imageName"), fit: BoxFit.cover);
}
