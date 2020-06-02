import 'dart:convert';

import 'package:spend_tracker/models/models.dart';
import 'package:http/http.dart' as http;

class Apis {
  static const String server = 'https://www.googleapis.com/';
  static const String key = 'AIzaSyCoJAKwJAuRWLOx2gkQk28YEZ8kPfZXWyM';
  static const String database = 'https://firestore.googleapis.com/v1';

  static const String documents =
      'projects/spendtracker-f64e7/databases/(default)/documents';
  String _securityToken;

  Future deleteItem(Item item) async {
    final url = '$database/${item.urlId}';
    var response = await http.delete(url, headers: _createHeader());
    _checkStatus(response);
  }

  Future<List<Item>> getItems() async {
    final url = '$database/$documents/item';
    var response = await http.get(url, headers: _createHeader());
    _checkStatus(response);
    return Item.fromJson(response.body);
  }

  Future createItem(Item item) async {
    final url = '$database/$documents/item';
    var response = await http.post(
      url,
      headers: _createHeader(),
      body: item.toJson(),
    );
    _checkStatus(response);
  }

  Future<List<Account>> getAccounts() async {
    final url = '$database/$documents/account';
    var response = await http.get(url, headers: _createHeader());
    _checkStatus(response);
    return Account.fromJson(response.body);
  }

  Future createAccount(Account account) async {
    final url = '$database/$documents/account';

    var response = await http.post(
      url,
      headers: _createHeader(),
      body: account.toJson(),
    );
    _checkStatus(response);
  }

  Future updateAccount(Account account) async {
    final url = '$database/${account.urlId}';

    var response = await http.patch(
      url,
      headers: _createHeader(),
      body: account.toJson(),
    );
    _checkStatus(response);
  }

  Future<List<ItemType>> getTypes() async {
    final url = '$database/$documents/type';
    var response = await http.get(url, headers: _createHeader());
    _checkStatus(response);
    return ItemType.fromJson(response.body);
  }

  Future createType(ItemType type) async {
    final url = '$database/$documents/type';
    var response = await http.post(
      url,
      headers: _createHeader(),
      body: type.toJson(),
    );
    _checkStatus(response);
  }

  Future updateType(ItemType type) async {
    final url = '$database/${type.urlId}';
    var response = await http.patch(
      url,
      headers: _createHeader(),
      body: type.toJson(),
    );
    _checkStatus(response);
  }

  Future login(String email, String password) async {
    final String url =
        '$server/identitytoolkit/v3/relyingparty/verifyPassword?key=$key';
    var response = await http.post(
      url,
      headers: _createHeader(),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    _checkStatus(response);

    var map = json.decode(response.body);
    _securityToken = LoginResponse.fromMap(map).idToken;
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode} ${response.body}');
    }
  }

  Map<String, String> _createHeader() {
    if (_securityToken != null) {
      var header = {
        "authorization": "Bearer $_securityToken",
        "Content-Type": "application/json"
      };
      return header;
    }

    return {"Content-Type": "application/json"};
  }
}
