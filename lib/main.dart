import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:services_app/users/screens/details_user_response.dart';
import './dashboard_services.dart';
import './users/screens/services_screen.dart';
import './users/screens/track_screen.dart';
import './Auth/auth_screen.dart';
import './users/screens/account_screen.dart';
import './admin/edit_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Services',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapShot) {
            if (userSnapShot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapShot.hasData) {
              return DashboardServices();
            } else {
              return AuthScreen();
            }
          }),
      routes: {
        ServicesScreen.routeName: (ctx) => ServicesScreen(),
        TrackScreen.routeName: (ctx) => TrackScreen(),
        AccountScreen.routeName: (ctx) => AccountScreen(),
        EditDeatilsScreen.routName: (ctx) => EditDeatilsScreen(),
        DetailsUserResponse.roteName: (ctx) => DetailsUserResponse(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
