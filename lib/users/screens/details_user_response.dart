import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsUserResponse extends StatefulWidget {
  static const roteName = '/details-user';

  @override
  _DetailsUserResponseState createState() => _DetailsUserResponseState();
}

class _DetailsUserResponseState extends State<DetailsUserResponse> {
  final _isLoading = false;
  var _isinit = true;
  var _oldMap = {
    'userId': '',
    'title': '',
    'descreption': '',
    'department': '',
    'fileUrl': '',
    'status': false,
    'feedback': '',
  };
  var _initVlues;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _oldMap = {
        'userId': data['userId'],
        'title': data['title'],
        'descreption': data['descreption'],
        'department': data['department'],
        'fileUrl': data['fileUrl'],
        'status': data['status'],
        'feedback': data['feedback'],
      };
      setState(() {
        _initVlues = _oldMap;
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  Future<void> openFile() async {
    final fileUrl = _initVlues['fileUrl'];
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      throw 'Could not launch $fileUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: _isLoading || _initVlues == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  Text(
                    'Department: \n' + _initVlues['department'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Title: \n' + _initVlues['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Descreption: \n' + _initVlues['descreption'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _initVlues['status'] == false
                      ? Text(
                          'Not Response',
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          'Done',
                          textAlign: TextAlign.center,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                      onPressed: openFile, child: Text('Open File or Image')),
                  SizedBox(
                    height: 20,
                  ),
                  _initVlues['feedback'] == ''
                      ? Text(
                          'There is no FeedBack',
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          'FeedBack: \n' + _initVlues['feedback'],
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                ],
              ),
            ),
    );
  }
}
