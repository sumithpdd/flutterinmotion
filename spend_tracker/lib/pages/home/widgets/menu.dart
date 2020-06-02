import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;

    return SizedBox(
      width: 150,
      child: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              alignment: AlignmentDirectional.bottomCenter,
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 20, color: color),
              ),
            ),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
              title: 'Accounts',
              icon: Icons.account_balance,
              color: color,
              onTap: () => onNavigation(context, '/accounts'),
            ),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
              title: 'Budget Items',
              icon: Icons.attach_money,
              color: color,
              onTap: () => onNavigation(context, '/items'),
            ),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
              title: 'Types',
              icon: Icons.widgets,
              color: color,
              onTap: () => onNavigation(context, '/types'),
            ),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
              title: 'Logout',
              icon: Icons.security,
              color: color,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
          ],
        ),
      ),
    );
  }

  void onNavigation(BuildContext context, String uri) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(uri);
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    Key key,
    @required this.color,
    @required this.title,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);

  final Color color;
  final String title;
  final IconData icon;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: 0.6,
        child: Container(
            height: 70,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Icon(
                  icon,
                  color: color,
                  size: 50,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
