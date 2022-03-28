import 'package:flutter/material.dart';

class LogginButton extends StatelessWidget {
  const LogginButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  final Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(fontSize: 25),
          )),
    ));
  }
}