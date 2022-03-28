import 'package:flutter/material.dart';

class LoginTextBox extends StatefulWidget {
  final TextEditingController? controller;
  final bool isPassword;
  final String? label;
  final String? initial;
  final Widget? icon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const LoginTextBox(
      {Key? key,
      this.label,
      this.icon,
      this.validator,
      this.onSaved,
      this.isPassword = false,
      this.initial, this.controller})
      : super(key: key);

  @override
  State<LoginTextBox> createState() => _LoginTextBoxState();
}

class _LoginTextBoxState extends State<LoginTextBox> {
  @override
  Widget build(BuildContext context) {
    debugPrint("Initiale value: " + (widget.initial??"ND"));
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label ?? (widget.isPassword ? "Mot de passe" : "Courriel"),
        suffixIcon: widget.icon ??
            (widget.isPassword ? const Icon(Icons.lock) : const Icon(Icons.mail)),
      ),
      obscureText: widget.isPassword,
      validator: widget.validator,
      initialValue: widget.initial,
      onSaved: widget.onSaved,
    );
  }
}