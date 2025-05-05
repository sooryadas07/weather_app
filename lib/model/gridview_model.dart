import 'package:flutter/cupertino.dart';

class ModelGridview{
  final IconData icon;
  final String title;
  final AssetImage image;
  final String ? text;
  final String ? name;








  ModelGridview({
    required this.title,
    required this.image,
    this.text,
    this.name,
    required this.icon,
});
}