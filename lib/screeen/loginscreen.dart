import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String logSig = "Login";
String error = "";
final databaseReference = FirebaseDatabase.instance.ref();

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginSignin() async {
    var email = nameController.text.toString();
    var password = passwordController.text.toString();
    var er = "";
    setState(() {
      error = "";
    });
    if (logSig == "Sign in") {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          er = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          er = 'The account already exists for that email.';
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          er = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          er = 'Wrong password provided for that user.';
        }
      }
    }
    setState(() {
      error = er;
    });
    if (error == "") {
      final string = email.substring(0, email.indexOf('.'));
      databaseReference.child(string).set({'password': password});
    }

    // DatabaseEvent event = await databaseReference.once();
    // print(event.snapshot.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Todo App',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: Text(logSig.toString()),
                    onPressed: loginSignin,
                  )),
              Row(
                children: [
                  Text((logSig == 'Sign in')
                      ? 'Already have a account'
                      : 'Does not have account?'),
                  TextButton(
                    child: Text(
                      (logSig == 'Sign in') ? 'Login' : 'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      setState(() {
                        if (logSig == 'Sign in') {
                          logSig = "Login";
                        } else {
                          logSig = "Sign in";
                        }
                      });
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Center(
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
