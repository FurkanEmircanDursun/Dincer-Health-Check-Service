import 'package:dincer_health_check_service/page/services_page.dart';
import 'package:dincer_health_check_service/page/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'overview_page.dart';

class BottomPage extends StatefulWidget {
  static String routeName = '/bottomPage';

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  static int currentIndex = 1;

  final screens = [OverViewPage(), ServicesPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        showUnselectedLabels: false,
        onTap: (index) => setState(() => (currentIndex = index)),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Overview"),
          BottomNavigationBarItem(icon: Icon(Icons.room_service), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
        ],
      ),
    );
  }
}
