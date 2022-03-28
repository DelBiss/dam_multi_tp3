
import 'package:dam_multi_tp3/login_text_box_value_controller.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'list_route.dart';
import 'login_button.dart';
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

  void Function() nextRoute(BuildContext context) {
    var myRoute = MaterialPageRoute(builder: (context) => const ListRoute());
    //When running as windows app, we don't have a back button
    return (){
      debugPrint("Going to next route");
      Navigator.push(context, myRoute);
      };
    
  }


  Function() connexion(BuildContext context){
    return (){
      if(_formKey.currentState!.validate()){
        _formKey.currentState!.save();
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
          LoginTextBox(controller: SharedPreferenceTextBox("email",validator: validateEmail),),
          LoginTextBox( isPassword: true ,controller: KeyChaineTextBox("password",validator: validateForm),),

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




