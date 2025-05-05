import 'package:flutter/material.dart';

class GridviewWidgets extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? text;
  final String image;

  const GridviewWidgets(
      {super.key,
      required this.title,
       required this.text,
      required this.image,
      required this.icon});

  @override
  State<GridviewWidgets> createState() => _GridviewWidgetsState();
}

class _GridviewWidgetsState extends State<GridviewWidgets> {
  @override
  Widget build(BuildContext context) {
    return Container(width: 300,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Card(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                ),Text(
                  widget.title,style: TextStyle(color: Colors.white),
                ),
                Image.asset(
                  widget.image,
                  height: 60,
                  width: 60,
                ),

                Text(
                  widget.text ??"",

                  style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w700),
                ),

                // Text(
                //   "use sun protection",
                //   style: TextStyle(fontSize: 10, color: Colors.white),
                // )
              ],

            ),
          ),
        ),
      ),
    );
  }
}
