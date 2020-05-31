import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/pages/icons/icon_holder.dart';
import 'package:spend_tracker/support/icon_helper.dart';

class TypePage extends StatefulWidget {
  final ItemType type;

  const TypePage({this.type});

  @override
  _TypePageState createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  Map<String, dynamic> _data;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.type != null) {
      _data = widget.type.toMap();
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
        title: const Text('Type'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                if (!_formKey.currentState.validate()) return;
                _formKey.currentState.save();
                var type = ItemType.fromMap(_data);
                if (type.id == null) {
                  await dbProvider.createItemType(type);
                } else {
                  await dbProvider.updateItemType(type);
                }
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
              IconHolder(
                newIcon: IconHelper.createIconData(_data['codePoint']),
                onIconChange: (IconData iconData) {
                  setState(() {
                    _data['codePoint'] = iconData.codePoint;
                  });
                },
              ),
              TextFormField(
                initialValue: widget.type != null ? widget.type.name : '',
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  return null;
                },
                onSaved: (String value) => _data['name'] = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
