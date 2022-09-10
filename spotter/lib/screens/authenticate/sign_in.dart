import 'package:flutter/material.dart';
import '../../services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text("Test sign in"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: ElevatedButton(
              child: const Text('Sign in Anon'),
              onPressed: () async {
                /** This is dynamic because it returns either the user or null,
                 * and the await keyword is ofc because the method is type Future
                 */
                dynamic result = await _auth.anonSignIn();
                if(result == null){
                  print('error signing in');
                }else{
                  print('signed in \n$result\n');
                  print(result.uid);
                }
              },
            )
        )
    );
  }
}
