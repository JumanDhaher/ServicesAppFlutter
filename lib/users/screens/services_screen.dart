import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ServicesScreen extends StatefulWidget {
  static const routeName = '/services-screen';

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {

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

  final _formKey = GlobalKey<FormState>();
  var _title = '';
  var _descreption = '';
  String _dropDownValue = 'Select Department';
  String _filePath;
  File _file;
  bool loadingButton = false;

  void _trySubmit(BuildContext ctx) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_dropDownValue == 'Select Department') {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Please select department'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (_filePath == null) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Please select file'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        loadingButton = true;
      });
      final user = await FirebaseAuth.instance.currentUser();
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_files')
          .child(user.uid + UniqueKey().toString());
      await ref.putFile(_file).onComplete;

      final url = await ref.getDownloadURL();
      await Firestore.instance.collection('compaint').add({
        'userId': user.uid,
        'department': _dropDownValue,
        'title': _title,
        'descreption': _descreption,
        'file_url': url,
        'createdAt': Timestamp.now(),
        'status': false,
        'feedback': '',
      }).then((value) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Your Submitton are Sucssess'),
                  content: Text('Waiting for response'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    )
                  ],
                ));
      });
    }
    Navigator.of(context).pop();
  }

  void getFilePath() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.any);
      if (filePath == '') {
        return;
      }
      print("File path: " + filePath);
      _file = File(filePath);
      setState(() {
        this._filePath = filePath;
      });
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  Widget _buildColumnUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FlatButton.icon(
            onPressed: getFilePath,
            icon: Icon(Icons.file_upload),
            label: Text('Upload file such as .jpg, .pdf, .zip')),
        Center(
          child: _filePath == null
              ? Text(
                  'No file selected.',
                  textAlign: TextAlign.center,
                )
              : Text(
                  'Path' + _filePath,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
        ),
      ],
    );
  }

  Widget _buildColumnSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Select a section: ',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButton(
            hint: _dropDownValue == null
                ? Text('Select')
                : Text(
                    _dropDownValue,
                    style: TextStyle(color: Colors.grey[900]),
                  ),
            iconSize: 30.0,
            style: TextStyle(color: Colors.black38),
            items: ['Seals Department', 'Server Department'].map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                () {
                  _dropDownValue = val;
                },
              );
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
      ),
      body: Builder(
        builder: (BuildContext innerContext) => Card(
          margin: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildColumnSection(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Submit a complaint:',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      key: ValueKey('Title'),
                      validator: (title) {
                        if (title.isEmpty) {
                          return 'Please enter a title!';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (title) {
                        _title = title;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextFormField(
                      key: ValueKey('Descreption'),
                      validator: (descreption) {
                        if (descreption.isEmpty || descreption.length < 10) {
                          return 'Please enter a Descreption! at least 10 charachter';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (descreption) {
                        _descreption = descreption;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'Descreption'),
                    ),
                    _buildColumnUpload(),
                    SizedBox(
                      height: 30,
                    ),
                    (loadingButton)
                        ? CircularProgressIndicator()
                        : FlatButton(
                            child: Text('Submit'),
                            onPressed: () => _trySubmit(innerContext),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
