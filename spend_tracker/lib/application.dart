import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/routes.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DbProvider>(
      create: (_) => DbProvider(),
      dispose: (_, value) => value.dispose(),
      child: MaterialApp(
        title: 'Spend Tracker',
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
