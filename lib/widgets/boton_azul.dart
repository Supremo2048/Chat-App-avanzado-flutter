import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  //se agrega "?" para que pueda permitir null
  final Function()? onPressed;

  const BotonAzul({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        elevation: 2,
        highlightElevation: 5,
        color: Colors.blue,
        shape: const StadiumBorder(),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
//variable// final Function onPressed; reemplazado como se ve arriba
/* reeemplazado por este boton

child: ElevatedButton(
        onPressed: (() {}),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromARGB(0, 244, 67, 54))))),
        child: const SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      )
*/