import 'package:flutter/material.dart';

class WeatherCelsiusWidgets extends StatefulWidget {
  final String time;
  final AssetImage image;
  final String celsius;
  const WeatherCelsiusWidgets({
    super.key,
    required this.time,
    required this.image,
    required this.celsius,
  });

  @override
  State<WeatherCelsiusWidgets> createState() => _WeatherCelsiusWidgetsState();
}

class _WeatherCelsiusWidgetsState extends State<WeatherCelsiusWidgets> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.time,
                  style: const TextStyle(
                    fontSize: 20,fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Image(
                  image: widget.image,
                  height: 32,
                  width: 32,
                ),
                Text(
                  widget.celsius,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
