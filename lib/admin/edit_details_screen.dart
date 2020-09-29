import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EditDeatilsScreen extends StatefulWidget {
  static const routName = '/edit-details';

  @override
  _EditDeatilsScreenState createState() => _EditDeatilsScreenState();
}

class _EditDeatilsScreenState extends State<EditDeatilsScreen> {
  @override
  void initState() {
    super.initState();

    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      return;
    }, onLaunch: (msg) {
      return;
    }, onResume: (msg) {
      return;
    });
    fbm.subscribeToTopic('compaint');
  }

  final _form = GlobalKey<FormState>();
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
  String docsID;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      docsID = data['docsId'];
    }
    _isinit = false;
  }

  _saveForm() async {
    _form.currentState.save();
    Firestore.instance.collection('compaint').document(docsID).updateData({
      'department': _initVlues['department'],
      'title': _initVlues['title'],
      'descreption': _initVlues['descreption'],
      'status': _initVlues['status'],
      'feedback': _initVlues['feedback']
    }).whenComplete(() {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Updeted'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  )
                ],
              ));
    }).then((value) => Navigator.of(context).pop());
  }

  Future<void> openFile() async {
    final fileUrl = _initVlues['fileUrl'] ?? '';
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
          title: Text('Response'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
          ],
        ),
        body: _isLoading || _initVlues == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _form,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          key: ValueKey('department'),
                          initialValue: _initVlues['department'],
                          decoration: InputDecoration(labelText: 'department'),
                          onSaved: (value) {
                            _initVlues = {
                              'userId': _initVlues['userId'],
                              'title': _initVlues['title'],
                              'descreption': _initVlues['descreption'],
                              'department': value,
                              'fileUrl': _initVlues['file_url'],
                              'status': _initVlues['status'],
                              'feedback': _initVlues['feedback'],
                            };
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a velue.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          key: ValueKey('title'),
                          initialValue: _initVlues['title'],
                          decoration: InputDecoration(labelText: 'title'),
                          onSaved: (value) {
                            _initVlues = {
                              'userId': _initVlues['userId'],
                              'title': value,
                              'descreption': _initVlues['descreption'],
                              'department': _initVlues['department'],
                              'fileUrl': _initVlues['file_url'],
                              'status': _initVlues['status'],
                              'feedback': _initVlues['feedback'],
                            };
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a velue.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          key: ValueKey('descreption'),
                          initialValue: _initVlues['descreption'],
                          maxLines: 3,
                          decoration: InputDecoration(labelText: 'descreption'),
                          onSaved: (value) {
                            _initVlues = {
                              'userId': _initVlues['userId'],
                              'title': _initVlues['title'],
                              'descreption': value,
                              'department': _initVlues['department'],
                              'fileUrl': _initVlues['file_url'],
                              'status': _initVlues['status'],
                              'feedback': _initVlues['feedback'],
                            };
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a velue.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          key: ValueKey('status'),
                          initialValue: _initVlues['status'].toString(),
                          decoration: InputDecoration(labelText: 'status'),
                          onSaved: (value) {
                            _initVlues = {
                              'userId': _initVlues['userId'],
                              'title': _initVlues['title'],
                              'descreption': _initVlues['descreption'],
                              'department': _initVlues['department'],
                              'fileUrl': _initVlues['file_url'],
                              'status': value == 'true',
                              'feedback': _initVlues['feedback'],
                            };
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a velue.';
                            }
                            return null;
                          },
                        ),
                        FlatButton(
                            onPressed: openFile,
                            child: Text('Open File or Image')),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _initVlues['feedback'],
                          key: ValueKey('FeedBack'),
                          decoration: InputDecoration(labelText: 'FeedBack'),
                          onSaved: (value) {
                            _initVlues = {
                              'userId': _initVlues['userId'],
                              'title': _initVlues['title'],
                              'descreption': _initVlues['descreption'],
                              'department': _initVlues['department'],
                              'fileUrl': _initVlues['file_url'],
                              'status': _initVlues['status'],
                              'feedback': value,
                            };
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a velue.';
                            }
                            return null;
                          },
                        ),
                        FlatButton(onPressed: _saveForm, child: Text('Submit')),
                      ],
                    )),
              ));
  }
}
