import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'bottom_page.dart';

class EditDataPage extends StatefulWidget {
  static int? index;
  static var dataRightNow;

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

Future<void> wait(BuildContext context) async {
  Fluttertoast.showToast(
      msg: "Loading...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0);
  Future.delayed(Duration(seconds: 3), () {
    Navigator.push(context, MaterialPageRoute(builder: (_) => BottomPage()));
  });
}

class _EditDataPageState extends State<EditDataPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var UrlText = TextEditingController();

//  var MethodText = TextEditingController();
  var StatusCodeText = TextEditingController();
  var RetryCountText = TextEditingController();
  var SecondPeriodText = TextEditingController();
  var dropdownValue;

  @override
  Widget build(BuildContext context) {
    var dataRightNow = EditDataPage.dataRightNow;
    UrlText.text = dataRightNow.url.toString();
    StatusCodeText.text = dataRightNow.responseStatus.toString();
    RetryCountText.text = dataRightNow.retryCount.toString();
    SecondPeriodText.text = dataRightNow.periodSeconds.toString();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: UrlText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Url',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black87),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['GET', 'PUT', 'POST', 'DELETE']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: StatusCodeText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Status Code',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: RetryCountText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Retry Count',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: SecondPeriodText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Second Period',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: () async {
                          var docUser = FirebaseFirestore.instance
                              .collection('Person')
                              .doc(_auth.currentUser?.uid)
                              .collection('ApiInfos')
                              .doc(dataRightNow.id);

                          await docUser.update({
                            'url': UrlText.text,
                            'method': dropdownValue.toString(),
                            'responseStatus': int.parse(StatusCodeText.text),
                            'retryCount': int.parse(RetryCountText.text),
                            'periodSeconds': int.parse(SecondPeriodText.text)
                          });
                          wait(context);
                        },
                        child: Icon(Icons.save),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      height: 100,
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: () {
                          var docUser = FirebaseFirestore.instance
                              .collection('Person')
                              .doc(_auth.currentUser?.uid)
                              .collection('ApiInfos')
                              .doc(dataRightNow.id);

                          docUser.delete();
                          wait(context);
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
