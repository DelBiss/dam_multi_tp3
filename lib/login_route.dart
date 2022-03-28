import 'package:flutter/material.dart';
import 'login.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                Expanded(child: CompagnieLogoMark(
                  logo:  Image.network('https://picsum.photos/1000?image=10'),
                  mark: "Bel-Air",
                )),
                const LoginWidget()
              ],
            )
          ),
        ),
      ),
    );
  }
}

class CompagnieLogoMark extends StatelessWidget {
  final Widget? logo;
  final String? mark;
  const CompagnieLogoMark({ Key? key, this.logo, this.mark }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> myPart = List.empty(growable: true);
    if (mark != null) {
      myPart.add(Expanded(
        flex: 1,
        child: FittedBox(
          child: Text(
            mark!,
            style: const TextStyle(fontSize: 100)
          ),
        ),
      ));
    }
    if (logo != null) {
      myPart.add(Expanded(child: logo!, flex: 2,));
    }
    return Column(
      children: myPart,
    );
  }
}