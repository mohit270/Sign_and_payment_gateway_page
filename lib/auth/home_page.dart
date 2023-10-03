import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  var user = FirebaseAuth.instance.currentUser!;
  void SignOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [IconButton(onPressed: SignOut, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: Text('logged in : ${user.email!}'),
      ),
    );
  }
}
