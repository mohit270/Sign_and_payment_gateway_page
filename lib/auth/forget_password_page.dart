import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign/auth/login_pages.dart';
import 'package:sign/auth/my_button.dart';
import 'package:sign/auth/my_textfield.dart';
import 'package:sign/pay/pay_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key, required this.cnt});
  final BuildContext cnt;

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final email = TextEditingController();

  void forgetPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Navigator.pop(widget.cnt);
      print(email.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showMessage(e.code);
    }
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Center(child: Text(message)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Forget Password')),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
              const SizedBox(
                height: 50,
              ),

              //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(
                height: 50,
              ),

              Text(
                "Forget your password ",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
              ),

              const SizedBox(
                height: 25,
              ),

              //username textfield
              MyTextField(
                  hintText: "Email Enter",
                  obsecureText: false,
                  controllers: email),

              const SizedBox(
                height: 25,
              ),
              // forgot password
              const SizedBox(
                height: 25,
              ),
              MyButton(
                onTap: forgetPassword,
                text: 'Forget Password',
              ),
            ])))));
  }
}
