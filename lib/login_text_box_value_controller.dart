

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_keychain/flutter_keychain.dart';


abstract class TextBoxValueController {
  final String? Function(String?)? validator;
  final String key;

  TextBoxValueController(this.key, {this.validator});
  Future<void> save(String? value);
  Future<TextEditingValue> load();
}

class SharedPreferenceTextBox extends TextBoxValueController{
  late SharedPreferences prefs;

  SharedPreferenceTextBox(String key, {String? Function(String?)? validator}):super(key,validator:validator);
  
  @override
  Future<TextEditingValue> load() async {
    prefs = await SharedPreferences.getInstance();
    return TextEditingValue(text: prefs.getString(key)??"");
  }

  @override
  Future<void> save(String? value) async {
    if (value != null){
      await prefs.setString(key, value);
    }
  }
}

class KeyChaineTextBox extends TextBoxValueController{
  KeyChaineTextBox(String key, {String? Function(String?)? validator}):super(key,validator:validator);
  
  @override
  Future<TextEditingValue> load() async {
    return TextEditingValue(text: (await FlutterKeychain.get(key: key))??"");
  }

  @override
  Future<void> save(String? value) async {
    if (value != null){
      await FlutterKeychain.put(key: key, value: value);
    }
  }
}