import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/home/widgets/custom_text.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'add',
            onPressed: () => print('click'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text(
              'One',style: TextStyle(
                fontSize: 40,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              ),
              ),
               const CustomText(
              text:'Two',
              ),
               const Text(
              'Three',
              ),
              Image.network('https://gravatar.com/avatar/1735fca48036474bb3e30abc295c1067',
              height:200)
           
          ],
        ),
      ),
    );
  }
}
