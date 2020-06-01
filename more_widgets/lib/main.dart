import 'package:flutter/material.dart';
import 'package:more_widgets/gridview_page.dart';

import 'notify_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: GridViewPage(),
      home: NotifyPage(),
    );
  }
}
