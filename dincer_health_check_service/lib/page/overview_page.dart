import 'dart:async';

import 'package:dincer_health_check_service/model/api_info_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/api_info_model.dart';
import '../model/api_model.dart';
import '../service/firestore.dart';
import 'bottom_page.dart';

class OverViewPage extends StatefulWidget {
  const OverViewPage({Key? key}) : super(key: key);

  @override
  State<OverViewPage> createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverViewPage> {
  FirestoreSevice _firestoreSevice = FirestoreSevice();

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

  Text isApiTrueOrFalse(ApiModel apiInfoModel) {
    if (apiInfoModel.isApiWorking.toString() == "true") {
      return Text(
        '✓',
        style: const TextStyle(color: Colors.green, fontSize: 30),
      );
    } else {
      return Text(
        'X',
        style: const TextStyle(color: Colors.red, fontSize: 30),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {});
        },
        child: StreamBuilder<List<ApiModel>>(
            stream: _firestoreSevice.readApiInfos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var datalist = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        title: Text(datalist[index].url!),
                        subtitle: Text(datalist[index].method!),
                        leading: isApiTrueOrFalse(datalist[index]),
                      ),
                    );
                  },
                  itemCount: datalist.length,
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
