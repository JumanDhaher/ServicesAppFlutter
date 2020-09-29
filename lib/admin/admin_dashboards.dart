import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './edit_details_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  var docsIDOpen = Set();
  var docsIDNotOpen = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          ),
          title: Text('Admin'),
        ),
        body: TabBarView(controller: _tabController, children: [
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
                    docs.forEach((docs) {
                      if (docs != null) {
                        docsIDNotOpen.add(docs.documentID.toString());
                      }
                    });
                    return cardDesign(
                        docs[i]['title'],
                        docs[i]['descreption'],
                        docs[i]['department'],
                        context,
                        docs[i]['userId'],
                        docs[i]['file_url'],
                        docs[i]['status'],
                        docs[i]['feedback'],
                        docsIDNotOpen.elementAt(i));
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
                    docs.forEach((docs) {
                      if (docs != null) {
                        docsIDOpen.add(docs.documentID.toString());
                      }
                    });
                    return cardDesign(
                        docs[i]['title'],
                        docs[i]['descreption'],
                        docs[i]['department'],
                        context,
                        docs[i]['userId'],
                        docs[i]['file_url'],
                        docs[i]['status'],
                        docs[i]['feedback'],
                        docsIDOpen.elementAt(i));
                  },
                  itemCount: docs.length,
                );
              }),
        ]));
  }
}

Widget cardDesign(
    String titile,
    String descreption,
    String department,
    BuildContext context,
    String userId,
    String fileUrl,
    bool status,
    String feedback,
    String docsID) {
  return Container(
    margin: EdgeInsets.all(10),
    child: ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: FittedBox(child: Text(department)),
      title: Text(
        titile,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(descreption),
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            var _value = {
              'userId': userId,
              'title': titile,
              'descreption': descreption,
              'department': department,
              'fileUrl': fileUrl,
              'status': status,
              'feedback': feedback,
              'docsId':docsID
            };
            Navigator.of(context)
                .pushNamed(EditDeatilsScreen.routName, arguments: _value);
          }),
    ),
  );
}
