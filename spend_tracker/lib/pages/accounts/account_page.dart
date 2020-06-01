import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/account.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';
import 'package:spend_tracker/support/icon_helper.dart';

class AccountPage extends StatefulWidget {
  final Account account;

  const AccountPage({this.account});
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic> _data;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _data = widget.account.toMap();
    } else {
      _data = Map<String, dynamic>();
      _data['codePoint'] = Icons.add.codePoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DbProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                if (!_formKey.currentState.validate()) return;
                _formKey.currentState.save();
                var account = Account.fromMap(_data);
                if (account.id == null) {
                  await dbProvider.createAccount(account);
                } else {
                  await dbProvider.updateAccount(account);
                }
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Form(
        key: _formKey,
        onWillPop: () {
          if (_hasChanges) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text('Discard Changes?'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes')),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'))
                    ],
                  );
                });
            return Future.value(false);
          }
          return Future.value(true);
        },
        // ()=> Future.value(!_hasChanges),
        onChanged: () => _hasChanges = true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              IconHolder(
                tagId: widget.account == null ? 0 : widget.account.id,
                newIcon: IconHelper.createIconData(_data['codePoint']),
                onIconChange: (IconData iconData) {
                  _hasChanges = true;
                  setState(() {
                    _data['codePoint'] = iconData.codePoint;
                  });
                },
              ),
              TextFormField(
                initialValue: widget.account != null ? widget.account.name : '',
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  return null;
                },
                onSaved: (String value) => _data['name'] = value,
              ),
              TextFormField(
                initialValue: widget.account != null
                    ? widget.account.balance.toString()
                    : '',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Balance',
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
                onSaved: (String value) =>
                    _data['balance'] = double.parse(value),
              )
            ],
          ),
        ),
      ),
    );
  }
}
