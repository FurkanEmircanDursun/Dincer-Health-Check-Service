import 'dart:async';

import 'package:dincer_health_check_service/service/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/api_info_model.dart';
import 'bottom_page.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({Key? key}) : super(key: key);

  @override
  State<AddDataPage> createState() => _AddDataPageState();
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

class _AddDataPageState extends State<AddDataPage> {
  var UrlText = TextEditingController();
  var StatusCodeText = TextEditingController();
  var RetryCountText = TextEditingController();
  var SecondPeriodText = TextEditingController();
  var dropdownValue = 'GET';
  FirestoreSevice _firestoreSevice = FirestoreSevice();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
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
                    dropdownValue = newValue!;
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton(
                  child: Icon(Icons.save),
                  onPressed: () {
                    _firestoreSevice.createApiInfo(
                        url: UrlText.text,
                        retryCount: int.parse(RetryCountText.text),
                        responseStatus: int.parse(StatusCodeText.text),
                        periodSeconds: int.parse(SecondPeriodText.text),
                        method: dropdownValue.toString(),
                        lastStatusCode: 0,
                        lastRetryCount: 0,
                        isApiWorking: false);

                    wait(context);
                  },
                ),
                SizedBox(
                  width: 20,
                  height: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
