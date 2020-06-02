import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, dynamic> _formData = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  StreamSubscription _subscription;
  bool _isLoggingIn = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_subscription == null) {
      _subscription = Provider.of<FirebaseBloc>(context)
          .loginStatus
          .listen(_onLoginSuccessful, onError: _onLoginEror);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _onLoginSuccessful(bool value) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onLoginEror(dynamic msg) async {
    setState(() {
      _isLoggingIn = false;
    });
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          print(msg);
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Login Faliure'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ok'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spend Tracker'),
      ),
      body: Stack(
        children: <Widget>[
          _LoginForm(
            formKey: _formKey,
            formData: _formData,
            onLogin: _onLogin,
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: _isLoggingIn ? CircularProgressIndicator() : Container(),
              ))
        ],
      ),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    setState(() {
      _isLoggingIn = true;
    });

    var bloc = Provider.of<FirebaseBloc>(context, listen: false);
    bloc.login(_formData['email'], _formData['password']);
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key key,
    @required this.formKey,
    @required this.formData,
    @required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final Function onLogin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 40, 20, 0),
      child: Form(
        key: formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email', icon: Icon(Icons.email)),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  return null;
                },
                onSaved: (String value) => formData['email'] = value,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.security),
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  return null;
                },
                onSaved: (String value) => formData['password'] = value,
              ),
              FlatButton(
                onPressed: onLogin,
                child: const Text('Login'),
              )
            ]),
      ),
    );
  }
}
