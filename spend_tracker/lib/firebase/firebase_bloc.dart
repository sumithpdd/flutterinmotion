import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:spend_tracker/firebase/apis.dart';
import 'package:spend_tracker/models/models.dart';

class FirebaseBloc {
  FirebaseBloc({@required this.apis});

  final _securityPubSub = PublishSubject<bool>();
  final _accountsBehavSub = BehaviorSubject<List<Account>>();
  final _typesBehavSub = BehaviorSubject<List<ItemType>>();
  final _itemsBehavSub = BehaviorSubject<List<Item>>();

  final Apis apis;

  Stream<bool> get loginStatus => _securityPubSub.stream;
  Stream<List<Account>> get accounts => _accountsBehavSub.stream;
  Stream<List<ItemType>> get itemTypes => _typesBehavSub.stream;
  Stream<List<Item>> get items => _itemsBehavSub.stream;

  Balance get balance {
    final items = _itemsBehavSub.value;
    double withdraw = 0;
    double deposit = 0;
    items.forEach((i) {
      if (i.isDeposit)
        deposit += i.amount;
      else
        withdraw += i.amount;
    });
    return Balance(
      deposit: deposit,
      withdraw: withdraw,
      total: deposit - withdraw,
    );
  }

  Future deleteItem(Item item) async {
    try {
      await apis.deleteItem(item);
      await getItems();
    } catch (err) {
      _itemsBehavSub.sink.addError(err.toString());
    }
  }

  Future getItems() async {
    try {
      var items = await apis.getItems();
      _itemsBehavSub.sink.add(items);
    } catch (err) {
      _itemsBehavSub.sink.addError(err.toString());
    }
  }

  Future createItem(Item item) async {
    try {
      await apis.createItem(item);
      await getItems();
    } catch (err) {
      _itemsBehavSub.sink.addError(err.toString());
    }
  }

  Future getTypes() async {
    try {
      var types = await apis.getTypes();
      _typesBehavSub.sink.add(types);
    } catch (err) {
      _typesBehavSub.sink.addError(err.toString());
    }
  }

  Future createType(ItemType type) async {
    try {
      await apis.createType(type);
      _typesBehavSub.sink.add(null);
      await getTypes();
    } catch (err) {
      _typesBehavSub.sink.addError(err.toString());
    }
  }

  Future updateType(ItemType type) async {
    try {
      await apis.updateType(type);
      _typesBehavSub.sink.add(null);
      await getTypes();
    } catch (err) {
      _typesBehavSub.sink.addError(err.toString());
    }
  }

  Future getAccounts() async {
    try {
      var accounts = await apis.getAccounts();
      _accountsBehavSub.sink.add(accounts);
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  Future createAccount(Account account) async {
    try {
      await apis.createAccount(account);
      _accountsBehavSub.sink.add(null);
      await getAccounts();
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  Future updateAccount(Account account) async {
    try {
      await apis.updateAccount(account);
      _accountsBehavSub.sink.add(null);
      await getAccounts();
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  void login(String email, String password) async {
    try {
      var futures = <Future>[];
      await apis.login(email, password);
      futures.add(getAccounts());
      futures.add(getTypes());
      futures.add(getItems());
      await Future.wait(futures);
      _securityPubSub.sink.add(true);
    } catch (err) {
      _securityPubSub.sink.addError(err.toString());
    }
  }

  void dispose() {
    _securityPubSub.close();
    _accountsBehavSub.close();
    _typesBehavSub.close();
    _itemsBehavSub.close();
  }
}
