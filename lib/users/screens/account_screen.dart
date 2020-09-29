import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account-screen';

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String name = '';
  String email = '';
  _user() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    setState(() {
      name = userData['username'];
      email = userData['email'];
    });
  }

  @override
  void initState() {
    _user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account'),
        ),
        body: Card(
          margin: EdgeInsets.all(20),
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  if (name == '')
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!(name == ''))
                    ListTile(
                      title: Text(name),
                      subtitle: Text(email),
                    ),
                ],
              )),
        ));
  }
}
