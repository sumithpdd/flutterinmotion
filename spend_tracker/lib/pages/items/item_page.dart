import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/account.dart';
import 'package:spend_tracker/models/item.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/routes.dart';

class ItemPage extends StatefulWidget {
  ItemPage({@required this.isDeposit});
  final bool isDeposit;
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> with RouteAware {
  Map<String, dynamic> _formData = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Account> _accounts = [];
  List<ItemType> _types = [];
  DateTime _dateTime = DateTime.now();
  void _loadDropDownData() async {
    var dbProvider = Provider.of<DbProvider>(context);
    var accounts = await dbProvider.getAllAccounts();
    var types = await dbProvider.getAllTypes();
    if (!mounted) return;

    setState(() {
      _accounts = accounts;
      _types = types;
    });
  }

  @override
  void initState() {
    super.initState();
    _formData['isDeposit'] = widget.isDeposit;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDropDownData();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  void didPopNext() {
    print('did pop next');
  }

  void didPushNext() {
    print('did push next');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (!_formKey.currentState.validate()) return;
                _formKey.currentState.save();
                var dbProvider =
                    Provider.of<DbProvider>(context, listen: false);
                _formData['date'] = DateFormat('MM/dd/yyyy').format(_dateTime);
                var item = Item.fromMap(_formData);
                dbProvider.createItem(item);
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  return null;
                },
                onSaved: (String value) => _formData['description'] = value,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
                onSaved: (String value) =>
                    _formData['amount'] = double.parse(value),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                      value: _formData['isDeposit'],
                      onChanged: (bool value) {
                        setState(() {
                          _formData['isDeposit'] = value;
                        });
                      }),
                  const Text("Is Deposit"),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime.now().add(
                          Duration(days: -365),
                        ),
                        lastDate: DateTime.now().add(
                          Duration(days: 365),
                        ),
                      );
                      if (date == null) return;
                      setState(() {
                        _dateTime = date;
                      });
                    },
                  ),
                  Text(DateFormat('MM/dd/yyyy').format(_dateTime)),
                ],
              ),
              DropdownButtonFormField<int>(
                value: _formData['accountId'],
                decoration: InputDecoration(
                  labelText: 'Account',
                ),
                items: _accounts
                    .map(
                      (a) => DropdownMenuItem<int>(
                        value: a.id,
                        child: Text(a.name),
                      ),
                    )
                    .toList(),
                validator: (int value) => value == null ? 'Required' : null,
                onChanged: (int value) {
                  setState(() {
                    _formData['accountId'] = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: _formData['typeId'],
                decoration: InputDecoration(
                  labelText: 'Type',
                ),
                items: _types
                    .map(
                      (type) => DropdownMenuItem<int>(
                        value: type.id,
                        child: Text(type.name),
                      ),
                    )
                    .toList(),
                validator: (int value) => value == null ? 'Required' : null,
                onChanged: (int value) {
                  setState(() {
                    _formData['typeId'] = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
