import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:services_app/admin/admin_dashboards.dart';
import './users/screens/track_screen.dart';
import './users/screens/account_screen.dart';
import './users/screens/services_screen.dart';

class DashboardServices extends StatefulWidget {
  @override
  _DashboardServicesState createState() => _DashboardServicesState();
}

class _DashboardServicesState extends State<DashboardServices> {
  Widget _buildContinear(Widget childButton) {
    return Container(
        padding: EdgeInsets.all(30),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: childButton,
        ),
        color: Colors.white10);
  }

  bool admin;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((docs) {
        if (docs.exists) {
          if (docs.data['role'] == 'admin') {
            setState(() {
              admin = true;
            });
          }
        }
      });
    });
    if (admin == null) {
      setState(() {
        admin = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: admin != null
          ? admin
              ? AppBar(
                  backgroundColor: Colors.white24,
                  actions: <Widget>[
                    FlatButton.icon(
                        icon: Icon(Icons.person_pin_circle),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => AdminDashboard())),
                        label: Text('Admin')),
                  ],
                )
              : AppBar(backgroundColor: Colors.white24)
          : AppBar(backgroundColor: Colors.white24),
      body: admin != null
          ? Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    color: Colors.black12,
                    child: (Text(
                      'Welcome In Our Services',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                  )),
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(colors: [
                        Colors.black38,
                        Colors.white24,
                      ], radius: 0.85, focal: Alignment.center),
                    ),
                    child: GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                      ),
                      children: <Widget>[
                        _buildContinear(FlatButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                ServicesScreen.routeName,
                              );
                            },
                            icon: Icon(
                              Icons.create,
                              size: 30,
                            ),
                            label: Text('Create\n your\n services'))),
                        _buildContinear(FlatButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(TrackScreen.routeName);
                            },
                            icon: Icon(Icons.check_box, size: 30),
                            label: Text('Track'))),
                        _buildContinear(FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.info, size: 30),
                            label: Text('help'))),
                        _buildContinear(FlatButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AccountScreen.routeName);
                            },
                            icon: Icon(Icons.account_box, size: 30),
                            label: Text('Account'))),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    color: Colors.black12,
                    child: FlatButton.icon(
                        label: Text('Log Out'),
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () => FirebaseAuth.instance.signOut()),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
