import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

import 'list_route.dart';
import 'login_textbox.dart';

String? validateEmail(String? value) {
  String? returnMsg;
  returnMsg = validateForm(value);

  if (returnMsg != null && value != null && !EmailValidator.validate(value)) {
    returnMsg = 'Entrez un courriel valide';
  }
  return returnMsg;
}

String? validateForm(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ce champ ne peut être vides';
  }
  return null;
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

 
  
  late SharedPreferences prefs;
  late TextEditingController _tecEmail;
  late TextEditingController _tecPassword;

  void Function() nextRoute(BuildContext context) {
    var myRoute = MaterialPageRoute(builder: (context) => const ListRoute());
    //When running as windows app, we don't have a back button
    return (){
      debugPrint("Going to next route");
      Navigator.push(context, myRoute);
      };
    
  }

  @override
  void initState() {
    super.initState();
    _tecEmail = TextEditingController();
    _tecPassword = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    prefs = await SharedPreferences.getInstance();
    String? _keychainPassword;
    if(Platform.isAndroid || Platform.isIOS){
      _keychainPassword = await FlutterKeychain.get(key: "password");
    } else{
        debugPrint("Platform doesn't support FlutterKeychain");
      }
    setState(() {
      debugPrint("SetState: " + (prefs.getString("email")??"Not found"));
      // _email = prefs.getString("email")??"Not found";
      _tecEmail.value = TextEditingValue(text: prefs.getString("email")??"") ;
      _tecPassword.value = TextEditingValue(text: _keychainPassword??"") ;
      // _password = _keychainPassword;
    });
  }

  void saveEmail(String? value) async {
    if (value != null){
      debugPrint("Saving email");
      await prefs.setString("email", value);
    }
  }
  void savePassword(String? value){
    if (value != null){
      if(Platform.isAndroid || Platform.isIOS){
        FlutterKeychain.put(key: "password", value: value);
      }
      else{
        debugPrint("Platform doesn't support FlutterKeychain");
      }
    }
  }

  Function() connexion(BuildContext context){
    return (){
      debugPrint("Trying to connect");
      if(_formKey.currentState!.validate()){
        debugPrint("Form is valid");
        _formKey.currentState!.save();
        debugPrint("Form is saved");
        nextRoute(context)();
      } else {
        debugPrint(
            "Erreur, les champs ne peuvent pas être vides et le courriel doit être valide");
      }
    };
  }
  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LoginTextBox(validator: validateEmail, onSaved: saveEmail, controller: _tecEmail,),
          LoginTextBox(validator: validateForm, isPassword: true,controller: _tecPassword, onSaved: savePassword,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LogginButton(onPressed: nextRoute(context), label: "Skip"),
              LogginButton(onPressed: connexion(context), label: "Connexion"),
            ],
          )
        ],
      ),
    );
  }
}



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
