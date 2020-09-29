import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:services_app/users/screens/details_user_response.dart';

class TrackScreen extends StatefulWidget {
  static const routeName = '/track-screen';

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'NOT OPEN'),
    Tab(text: 'OPEN'),
  ];

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  String userid;
  @override
  void didChangeDependencies() async {
    final user = await FirebaseAuth.instance.currentUser();
    userid = user.uid;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          ),
          title: Text('Tack'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            StreamBuilder(
                stream: Firestore.instance
                    .collection('compaint')
                    .where('status', isEqualTo: false)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data.documents;
                  return ListView.builder(
                    itemBuilder: (ctx, i) {
                      if (docs[i]['userId'] == userid) {
                        return cardDesign(
                          docs[i]['title'],
                          docs[i]['descreption'],
                          docs[i]['department'],
                          Colors.red,
                          context,
                          userid,
                          docs[i]['file_url'],
                          docs[i]['status'],
                          docs[i]['feedback'],
                        );
                      }
                      return Text('');
                    },
                    itemCount: docs.length,
                  );
                }),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('compaint')
                    .where('status', isEqualTo: true)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data.documents;
                  return ListView.builder(
                    itemBuilder: (ctx, i) {
                      if (docs[i]['userId'] == userid) {
                        return cardDesign(
                          docs[i]['title'],
                          docs[i]['descreption'],
                          docs[i]['department'],
                          Colors.green,
                          context,
                          userid,
                          docs[i]['file_url'],
                          docs[i]['status'],
                          docs[i]['feedback'],
                        );
                      }
                      return Text('');
                    },
                    itemCount: docs.length,
                  );
                }),
          ],
        ));
  }
}

Widget cardDesign(
    String titile,
    String descreption,
    String department,
    Color color,
    BuildContext context,
    String userid,
    String fileUrl,
    bool status,
    String feedback) {
  return Container(
    margin: EdgeInsets.all(10),
    child: ListTile(
        onTap: () {
          var _value = {
            'userId': userid,
            'title': titile,
            'descreption': descreption,
            'department': department,
            'fileUrl': fileUrl,
            'status': status,
            'feedback': feedback,
          };
          Navigator.of(context)
              .pushNamed(DetailsUserResponse.roteName, arguments: _value);
        },
        contentPadding: EdgeInsets.all(10),
        leading: FittedBox(child: Text(department)),
        title: Text(
          titile,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(descreption),
        trailing: Icon(
          Icons.arrow_right,
          color: color,
          size: 30,
        )),
  );
}
