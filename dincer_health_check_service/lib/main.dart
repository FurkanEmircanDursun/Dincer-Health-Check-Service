import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dincer_health_check_service/model/api_info_model.dart';
import 'package:dincer_health_check_service/model/api_model.dart';
import 'package:dincer_health_check_service/page/bottom_page.dart';
import 'package:dincer_health_check_service/page/login_page.dart';
import 'package:dincer_health_check_service/service/firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:push_notification/push_notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

final _fireStore = FirebaseFirestore.instance;

Future<List<ApiModel>> getData() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _fireStore
      .collection('Person')
      .doc(_auth.currentUser?.uid)
      .collection('ApiInfos')
      .get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs
      .map((doc) => ApiModel.fromJson(doc.data() as Map<String, dynamic>))
      .toList();
  //for a specific field
//  final allData = querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();
  return allData;
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  // service.startService();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

Future apiCheck(ApiModel apiInfoModel) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var docUser = FirebaseFirestore.instance
      .collection('Person')
      .doc(_auth.currentUser?.uid)
      .collection('ApiInfos')
      .doc(apiInfoModel.id);

  try {
    /*  if (apiInfoModel.method == 'GET') {
      var response = await Dio().get(apiInfoModel.url);

      print("my status code${response.statusCode}");
    } */

    switch (apiInfoModel.method) {
      case 'GET':
        var response = await Dio().get(apiInfoModel.url!);
        apiInfoModel.lastStatusCode = response.statusCode;

        break;

      case 'PUT':
        var response = await Dio().put(apiInfoModel.url!);
        apiInfoModel.lastStatusCode = response.statusCode;
        break;

      case 'POST':
        var response = await Dio().post(apiInfoModel.url!);
        apiInfoModel.lastStatusCode = response.statusCode;

        break;
      case 'DELETE':
        var response = await Dio().delete(apiInfoModel.url!);
        apiInfoModel.lastStatusCode = response.statusCode;

        break;
    }
    await docUser.update({
      'lastStatusCode': apiInfoModel.lastStatusCode,
    });
    print("My Url= ${apiInfoModel.url}"
        " My Method= ${apiInfoModel.method}"
        " My LastStatusCode= ${apiInfoModel.lastStatusCode}");

    //404
  } on DioError catch (e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    print(
        "my error statusCode =${e.response?.statusCode} my url =${apiInfoModel.url}  my error message= ${e.message} ");
    apiInfoModel.lastStatusCode = e.response?.statusCode;
    await docUser.update({
      'lastStatusCode': apiInfoModel.lastStatusCode,
    });

    print("My Url= ${apiInfoModel.url}"
        "My Method= ${apiInfoModel.method}"
        "My LastStatusCode= ${apiInfoModel.lastStatusCode}");
  }
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

// var box = Hive.box<ApiInfoModel>('myApiInfo');

//box.getAt(0).

  // bring to foreground

  // await Hive.initFlutter();
  //Hive.registerAdapter(ApiInfoModelAdapter());

  //  var myApiBox = await Hive.openBox<ApiInfoModel>('myApiBox');

  await Firebase.initializeApp();

  String notificationKey = 'key';
  Notificator? notification;
  notification = Notificator(
    onPermissionDecline: () {
      // ignore: avoid_print
      print('permission decline');
    },
    onNotificationTapCallback: (notificationData) {},
  )..requestPermissions(
      requestSoundPermission: true,
      requestAlertPermission: true,
    );

  List<ApiModel> myData = await getData();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  print(myData.length);
  for (int i = 0; i < myData.length; i++) {
    Timer.periodic(Duration(seconds: myData[i].periodSeconds!), (timer) async {
      //  final hello = preferences.getString("hello");
      // print(hello);

      await apiCheck(myData[i]);
      if (myData[i].responseStatus == myData[i].lastStatusCode) {
        print("${myData[i].url} api is working");
        myData[i].isApiWorking = true;
        myData[i].lastRetryCount = 0;
        var docUser = FirebaseFirestore.instance
            .collection('Person')
            .doc(_auth.currentUser?.uid)
            .collection('ApiInfos')
            .doc(myData[i].id);

        await docUser.update({
          'isApiWorking': myData[i].isApiWorking,
          'lastRetryCount': myData[i].lastRetryCount,
          'lastStatusCode': myData[i].lastStatusCode,
        });

        //  myApiBox.putAt(i, myApiBox.getAt(i)!);
      }

      if (myData[i].retryCount == myData[i].lastRetryCount) {
        print(
            "${myData[i].url} maximum error limit reached ! api is not working");

        var localUrl = myData[i].url;
        myData[i].isApiWorking = false;
        myData[i].lastRetryCount = 0;
        var docUser = FirebaseFirestore.instance
            .collection('Person')
            .doc(_auth.currentUser?.uid)
            .collection('ApiInfos')
            .doc(myData[i].id);

        await docUser.update({
          'isApiWorking': myData[i].isApiWorking,
          'lastRetryCount': myData[i].lastRetryCount,
        });

        //  await myApiBox.putAt(i, myApiBox.getAt(i)!);
        await notification?.show(
          i,
          'maximum error limit reached ! api is not working"',
          localUrl!,
          data: {notificationKey: '[notification data]'},
          notificationSpecifics: NotificationSpecifics(
            AndroidNotificationSpecifics(
              autoCancelable: true,
            ),
          ),
        );
      }
      if (myData[i].lastStatusCode != myData[i].responseStatus) {
        myData[i].lastRetryCount = (myData[i].lastRetryCount)! + 1;

        var docUser = FirebaseFirestore.instance
            .collection('Person')
            .doc(_auth.currentUser?.uid)
            .collection('ApiInfos')
            .doc(myData[i].id);

        await docUser.update({
          'lastRetryCount': myData[i].lastRetryCount,
        });

        //      await myApiBox.putAt(i, myApiBox.getAt(i)!);
      }

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Check Service is Running",
          content: "Updated at ${DateTime.now()}",
        );
      }
      print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

      /// you can see this log in logcat

      // test using external plugin
      final deviceInfo = DeviceInfoPlugin();
      String? device;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
      }

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    });
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        BottomPage.routeName: (context) => BottomPage(),
        LoginPage.routeName: (context) => LoginPage()
      },
    );
  }
}
