import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/icons/icons_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic> _data = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconData _newIcon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  if (!_formKey.currentState.validate()) return;
                  _formKey.currentState.save();
                  Navigator.of(context).pop();
                })
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    var iconData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IconsPage(),
                      ),
                    );
                    setState(() {
                      _newIcon = iconData;
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blueGrey),
                    ),
                    child: Icon(
                      _newIcon == null ? Icons.add : _newIcon,
                      size: 60,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) return 'Required';
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Balance',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid number';
                  },
                  onSaved: (String value) => _data['balance'] = value,
                )
              ],
            ),
          ),
        ));
  }
}
