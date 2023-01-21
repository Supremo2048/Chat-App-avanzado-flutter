import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String titulo;
  final String subTutulo;

  const Labels(
      {super.key,
      required this.route,
      required this.titulo,
      required this.subTutulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Text(
              subTutulo,
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, route);
            },
          )
        ],
      ),
    );
  }
}
