import 'package:flutter/material.dart';

class LoginResponse {
  String kind;
  String localId;
  String email;
  String displayName;
  String idToken;
  bool registered;
  String refreshToken;
  int expiresIn;

  LoginResponse(
      {@required this.kind,
      @required this.localId,
      @required this.email,
      this.displayName,
      @required this.idToken,
      @required this.registered,
      @required this.refreshToken,
      @required this.expiresIn});

  factory LoginResponse.fromMap(Map<String, dynamic> map) => LoginResponse(
      kind: map['kind'],
      localId: map['localId'],
      email: map['email'],
      displayName: map['displayName'],
      idToken: map['idToken'],
      registered: map['registered'],
      refreshToken: map['refreshToken'],
      expiresIn: int.parse(map['expiresIn']));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['localId'] = this.localId;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['idToken'] = this.idToken;
    data['registered'] = this.registered;
    data['refreshToken'] = this.refreshToken;
    data['expiresIn'] = this.expiresIn;
    return data;
  }
}
