import 'package:dam_multi_tp3/login_text_box_value_controller.dart';
import 'package:flutter/material.dart';

class LoginTextBox extends StatefulWidget {
  final TextBoxValueController controller;
  final bool isPassword;
  final String? label;
  final Widget? icon;
  
  const LoginTextBox(
    {
      Key? key,
      this.label,
      this.icon,
      this.isPassword = false, required this.controller,
    }
  ): super(key: key);

  @override
  State<LoginTextBox> createState() => _LoginTextBoxState();
}

class _LoginTextBoxState extends State<LoginTextBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    TextEditingValue initialeValue = await widget.controller.load();
    setState(() {
      _controller.value = initialeValue;
    });
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label ?? (widget.isPassword ? "Mot de passe" : "Courriel"),
        suffixIcon: widget.icon ??
            (widget.isPassword ? const Icon(Icons.lock) : const Icon(Icons.mail)),
      ),
      obscureText: widget.isPassword,
      validator: widget.controller.validator,
      onSaved: widget.controller.save
    );
  }
}