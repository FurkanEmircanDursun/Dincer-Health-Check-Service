import 'package:dincer_health_check_service/page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:push_notification/push_notification.dart';

import '../service/auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

Future<void> wait(BuildContext context) async {
  Fluttertoast.showToast(
      msg: "exiting...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0);
  Future.delayed(Duration(seconds: 2), () {
    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
  });
}

Future<void> start() async {
  final service = FlutterBackgroundService();
  service.startService();
}

Future<void> stop() async {
  final service = FlutterBackgroundService();
  service.invoke('stopService');
}

class _SettingsPageState extends State<SettingsPage> {
  late Notificator notification;

  String notificationKey = 'key';
  String _bodyText = 'notification test';

  void initState() {
    super.initState();
    notification = Notificator(
      onPermissionDecline: () {
        // ignore: avoid_print
        print('permission decline');
      },
      onNotificationTapCallback: (notificationData) {
        setState(
          () {
            _bodyText = 'notification open: '
                '${notificationData[notificationKey].toString()}';
          },
        );
      },
    )..requestPermissions(
        requestSoundPermission: true,
        requestAlertPermission: true,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 40,
                    onPressed: () {
                      AuthService _auth = AuthService();

                      _auth.signOut();
                      stop();
                      wait(context);
                    },
                    icon: Icon(
                      Icons.logout_sharp,
                      color: Colors.red[400],
                    ),
                  )
                ],
              ),
              SizedBox(height: 200,),
              Row(
                children: [

                  Expanded(
                    child: IconButton(
                        iconSize: 80,
                        onPressed: start,
                        icon: Icon(
                          Icons.play_circle_fill,
                          color: Colors.blueAccent,
                        )),
                  ),
               
                  Expanded(
                    child: IconButton(
                      iconSize: 80,
                      onPressed: stop,
                      icon: Icon(
                        Icons.stop_circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        iconSize: 80,
                        onPressed: () {
                          notification.show(
                            1,
                            'hello',
                            'this is test',
                            imageUrl:
                                'https://www.dincerlojistik.com.tr/assets/front/img/logo-dincer.png',
                            data: {notificationKey: '[notification data]'},
                            notificationSpecifics: NotificationSpecifics(
                              AndroidNotificationSpecifics(
                                autoCancelable: true,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.notifications_active,
                            color: Colors.blueGrey)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
